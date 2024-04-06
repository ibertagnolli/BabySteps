import 'package:babysteps/app/pages/user/userWidgets/baby_box.dart';
import 'package:babysteps/app/pages/user/userWidgets/build_info_box.dart';
import 'package:babysteps/app/pages/user/userWidgets/build_info_field.dart';
import 'package:babysteps/app/pages/user/user_database.dart';
import 'package:babysteps/app/widgets/styles.dart';
import 'package:babysteps/main.dart';
import 'package:babysteps/model/baby.dart';
import 'package:babysteps/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile userProfile = currentUser.value!;
  List<Baby> babyList = currentUser.value!.babies!;
  TextEditingController babyCode = TextEditingController();

  late UserProfile updatedUser = UserProfile(
      name: userProfile.name,
      email: userProfile.email,
      uid: userProfile.uid,
      userDoc: userProfile.userDoc,
      currentBaby: userProfile.currentBaby,
      babies: userProfile.babies);

  bool editing = false;
  bool addingBaby = false;

  void buttonClicked() async {
    if (editing) {
      List<String> babyIds = [];
      await FirebaseAuth.instance.currentUser
          ?.updateDisplayName(updatedUser.name);

      // try {
      //   FirebaseAuth.instance.currentUser?.updateEmail(updatedUser.email!);
      // } catch (e) {
      //   print(e);
      // }
      for (Baby baby in updatedUser.babies!) {
        babyIds.add(baby.collectionId);
        await UserDatabaseMethods()
            .updateBaby(baby.collectionId, baby.name, baby.dob);
      }

      await UserDatabaseMethods()
          .updateUserBabies(updatedUser.userDoc, babyIds);
    }
    setState(() {
      editing = !editing;
      addingBaby = false;
      currentUser.value = updatedUser;
    });
  }

  void updateUserName(String? _, String newVal) {
    updatedUser.name = newVal;
  }

  void updateUserEmail(String? _, String newVal) {
    updatedUser.email = newVal;
  }

  void createBaby() async {
    Map<String, dynamic> uploaddata = {
      'DOB': DateTime.now(),
      'Name': '',
      'Caregivers': [],
      'PrimaryCaregiverUID': currentUser.value!.uid,
      'SocialUsers': []
    };
    DocumentReference babyRef = await UserDatabaseMethods().addBaby(uploaddata);
    setState(
      () {
        updatedUser.addBaby(
          Baby(
            name: '',
            dob: DateTime.now(),
            collectionId: babyRef.id,
            caregivers: [],
            primaryCaregiverUid: currentUser.value!.uid,
            socialUsers: [],
          ),
        );
      },
    );
  }

  /// Creates a new caregiver user associated with an existing baby
  uploadBabyToCaregiver(String babyCode) async {
    try {
      // Add the caregiver user to the baby's list of caregivers
      DocumentSnapshot snapshot = await UserDatabaseMethods().getBaby(babyCode);
      Map<String, dynamic> doc = snapshot.data()! as Map<String, dynamic>;
      List<dynamic> caregivers = doc['Caregivers'];
      caregivers.add({
        'name': currentUser.value!.name,
        'doc': currentUser.value!.userDoc,
        'uid': currentUser.value!.uid
      });
      await UserDatabaseMethods().updateBabyCaregiver(babyCode, caregivers);

      setState(
        () {
          updatedUser.addBaby(
            Baby(
              name: doc['Name'],
              dob: (doc['DOB'] as Timestamp).toDate(),
              collectionId: snapshot.id,
              caregivers: caregivers,
              primaryCaregiverUid: doc['PrimaryCaregiverUID'],
              socialUsers: doc['socialUsers'],
            ),
          );
        },
      );
    } catch (e) {
      print('invalid code ${e.toString()}');
    }
  }

  uploadBabyToSocialUser(String babyCode) async {
    try {
      // Add the caregiver user to the baby's list of social only users
      DocumentSnapshot snapshot = await UserDatabaseMethods().getBaby(babyCode);
      Map<String, dynamic> doc = snapshot.data()! as Map<String, dynamic>;
      List<dynamic> socialUsers = doc['SocialUsers'] ?? [];
      socialUsers.add({
        'name': currentUser.value!.name,
        'doc': currentUser.value!.userDoc,
        'uid': currentUser.value!.uid
      });
      await UserDatabaseMethods().updateBabySocialUser(babyCode, socialUsers);

      setState(
        () {
          updatedUser.addBaby(
            Baby(
              name: doc['Name'],
              dob: (doc['DOB'] as Timestamp).toDate(),
              collectionId: snapshot.id,
              caregivers: doc['Caregivers'],
              primaryCaregiverUid: doc['PrimaryCaregiverUID'],
              socialUsers: socialUsers,
            ),
          );
        },
      );
    } catch (e) {
      print('invalid code ${e.toString()}');
    }
  }

  void showBabyAddCodeDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Baby Code:"),
                      TextField(
                        controller: babyCode,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          String babyCodeText = babyCode.text.endsWith("_SOU")
                              ? babyCode.text
                                  .substring(0, babyCode.text.length - 4)
                              : babyCode.text;
                          bool newBabyForUser = true;

                          if (currentUser.value!.babies != null) {
                            for (Baby baby in currentUser.value!.babies!) {
                              if (babyCodeText == baby.collectionId) {
                                newBabyForUser = false;
                              }
                            }
                          }

                          if (newBabyForUser &&
                              babyCode.text.endsWith("_SOU")) {
                            uploadBabyToSocialUser(babyCodeText);
                          } else if (newBabyForUser) {
                            uploadBabyToCaregiver(babyCodeText);
                          }

                          Navigator.pop(context);
                          babyCode.text = '';
                        },
                        style: blueButton(context),
                        child: const Text('Add baby'),
                      ),
                    ],
                  )));
        });
  }

  void showAddBabyOptions() {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        createBaby();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'New Child',
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showBabyAddCodeDialog();
                      },
                      child: Text(
                        'From A Code',
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  void updateBabyName(String? id, String newVal) {
    Baby? updateBaby = updatedUser.babies!
        .where((baby) => baby.collectionId == id)
        .firstOrNull;
    if (updateBaby != null) {
      updateBaby.name = newVal;
    } else {
      print(
          'error finding baby in collection! $id ${updatedUser.babies!.length}');
    }
  }

  void updateBabyDOB(String? id, String newVal) {
    Baby? updateBaby = updatedUser.babies!
        .where((baby) => baby.collectionId == id)
        .firstOrNull;
    if (updateBaby != null) {
      updateBaby.dob = DateFormat.yMd().parse(newVal);
    } else {
      print('error finding baby in collection!');
    }
  }

  @override
  void initState() {
    super.initState();
    updatedUser.babies = userProfile.babies;
    updatedUser.email = userProfile.email;
    updatedUser.name = userProfile.name;
    updatedUser.uid = userProfile.uid;
    updatedUser.userDoc = userProfile.userDoc;
    // Fetch user information when the page is initialized
    // fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile Image
              Container(
                height: 120,
                width: 120,
                margin: const EdgeInsets.only(top: 0, bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(2, 2),
                        blurRadius: 10)
                  ],
                  image: const DecorationImage(
                      image: AssetImage('assets/BabyStepsLogo.png')),
                ),
              ),

              // User's profile info box
              BuildInfoBox(label: '', fields: [
                BuildInfoField('Name', [currentUser.value!.name],
                    const Icon(Icons.account_box), editing, updateUserName),
                BuildInfoField(
                    'Email',
                    [userProfile.email],
                    const Icon(Icons.email),
                    editing,
                    updateUserEmail), // TODO make this just a text field, not editable
              ]),

              //create children info box and put in fields
              //TODO: display multiple baby's info when caregivers have more than one

              for (Baby element in babyList)
                BabyBox(
                    element.name,
                    element.dob,
                    element.caregivers,
                    editing,
                    updateBabyName,
                    updateBabyDOB,
                    element.collectionId,
                    element.socialUsers ?? [],
                    element.primaryCaregiverUid == currentUser.value!.uid),

              if (editing)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ElevatedButton(
                    onPressed: showAddBabyOptions,
                    style: blueButton(context),
                    child:
                        const Text('Add Child', style: TextStyle(fontSize: 26)),
                  ),
                ),

              //edit button
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: buttonClicked,
                  style: blueButton(context),
                  child: Text(editing ? 'Save' : 'Edit',
                      style: const TextStyle(fontSize: 26)),
                ),
              ),
              const SizedBox(height: 16),

              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    currentUser.value = null;
                    context.go('/login');
                  },
                  style: blueButton(context),
                  child: const Text('Logout', style: TextStyle(fontSize: 26)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
