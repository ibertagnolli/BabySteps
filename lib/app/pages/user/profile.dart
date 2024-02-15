import 'package:babysteps/app/pages/user/user_database.dart';
import 'package:babysteps/app/widgets/profile_widgets.dart';
import 'package:babysteps/app/widgets/styles.dart';
import 'package:babysteps/main.dart';
import 'package:babysteps/model/baby.dart';
import 'package:babysteps/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  UserProfile userProfile = currentUser;
  List<Baby> babyList = currentUser.babies;

  UserProfile updatedUser = UserProfile();

  bool editing = false;
  bool addingBaby = false;

  void buttonClicked() async {
    if (editing) {
      List<String> babyIds = [];
      FirebaseAuth.instance.currentUser?.updateDisplayName(updatedUser.name);

      // try {
      //   FirebaseAuth.instance.currentUser?.updateEmail(updatedUser.email!);
      // } catch (e) {
      //   print(e);
      // }
      for (Baby baby in updatedUser.babies) {
        print(baby.name);
        print(baby.dob);
        babyIds.add(baby.collectionId ?? '');
        await UserDatabaseMethods().updateBaby(
            baby.collectionId ?? 'IYyV2hqR7omIgeA4r7zQ',
            baby.name ?? 'Theo',
            baby.dob ?? DateTime.now());
      }

      await UserDatabaseMethods().updateUserBabies(
          updatedUser.userDoc ?? 'T6eKIIOFF6uf6GTSCSD7', babyIds);
    }
    setState(() {
      editing = !editing;
      addingBaby = false;
      currentUser = updatedUser;
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
      'Caregivers': [
        {
          'name': currentUser.name,
          'doc': currentUser.userDoc,
          'uid': currentUser.uid
        }
      ]
    };
    DocumentReference babyRef = await UserDatabaseMethods().addBaby(uploaddata);
    setState(() {
      updatedUser.addBaby(Baby(collectionId: babyRef.id, caregivers: [
        {
          'name': currentUser.name ?? '',
          'doc': currentUser.userDoc ?? '',
          'uid': currentUser.uid ?? ''
        }
      ]));
    });
  }

  void updateBabyName(String? id, String newVal) {
    Baby? updateBaby =
        updatedUser.babies.where((baby) => baby.collectionId == id).firstOrNull;
    if (updateBaby != null) {
      updateBaby.name = newVal;
    } else {
      print(
          'error finding baby in collection! $id ${updatedUser.babies.length}');
    }
  }

  void updateBabyDOB(String? id, String newVal) {
    Baby? updateBaby =
        updatedUser.babies.where((baby) => baby.collectionId == id).firstOrNull;
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
    return Scaffold(
      appBar: AppBar(
          title: const Text('Profile'),
          leading: BackButton(
              onPressed: () => context.go('/home'),
              color: Theme.of(context).colorScheme.onSurface)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //container is for the placeholder profile image
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
                //create user info box and put in fields
                BuildInfoBox(label: '', fields: [
                  BuildInfoField('Name', [userProfile.name ?? ''],
                      const Icon(Icons.account_box), editing, updateUserName),
                  BuildInfoField('Email', [userProfile.email ?? ''],
                      const Icon(Icons.email), editing, updateUserEmail),
                  //buildInfoField('Date of Birth', userProfile?.dateOfBirth?.toString()),
                ]),
                //create children info box and put in fields
                //TODO: display multiple baby's info when caregivers have more than one

                for (Baby element in babyList)
                  BabyBox(
                      element.name ?? '',
                      element.dob ?? DateTime.now(),
                      element.caregivers ?? [],
                      editing,
                      updateBabyName,
                      updateBabyDOB,
                      element.collectionId ?? 'N/A'),

                if (editing)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: ElevatedButton(
                      onPressed: createBaby,
                      style: blueButton(context),
                      child: const Text('Add Child',
                          style: TextStyle(fontSize: 26)),
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
                      currentUser = UserProfile();
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
      ),
    );
  }
}
