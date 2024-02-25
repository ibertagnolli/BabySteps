import 'package:babysteps/app/pages/user/user_database.dart';
import 'package:babysteps/app/pages/user/user_widgets/baby_box.dart';
import 'package:babysteps/app/pages/user/user_widgets/user_info_card.dart';
import 'package:babysteps/app/pages/user/user_widgets/build_info_field.dart';
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

  // The user with updated info data after User edits their profile
  UserProfile updatedUser = UserProfile(name: "EmTestUser", email: "emtestuser@email.com", uid: "emTestUid", userDoc: "emTestUserDoc");

  // True when User is editing their profile
  bool editing = false;

/// Updates User and Baby Info
  void editButtonClicked() async {
    if (editing) {
      // Update the User's name
      FirebaseAuth.instance.currentUser?.updateDisplayName(updatedUser.name);
      
      List<String> babyIds = [];

      // Update each baby's info
      for (Baby baby in updatedUser.babies) {
        babyIds.add(baby.collectionId);
        await UserDatabaseMethods().updateBaby(
            baby.collectionId,
            baby.name,
            baby.dob
        );
      }

      // Update User's list of connected babies, in case they added a baby
      await UserDatabaseMethods().updateUserBabies(
          updatedUser.userDoc, babyIds);
    }
    
    // Update state of the app to represent the edited data 
    setState(() {
      editing = !editing;
      currentUser = updatedUser;
    });
  }

  void updateUserName(String? _, String newVal) {
    updatedUser.name = newVal;
  }

  void updateUserEmail(String? _, String newVal) {
    updatedUser.email = newVal;
  }

  /// Creates a new baby and adds the baby to the database
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
      updatedUser.addBaby(Baby(name: "EmTest", dob: DateTime.now(), collectionId: babyRef.id, caregivers: [
        {
          'name': currentUser.name,
          'doc': currentUser.userDoc,
          'uid': currentUser.uid,
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
      print('error finding baby in collection! $id ${updatedUser.babies.length}');
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
      // Nav Bar
      appBar: AppBar(
          title: const Text('Profile'),
          leading: BackButton(
              onPressed: () => context.go('/home'),
              color: Theme.of(context).colorScheme.onSurface
          )
      ),
      
      // Page Widgets         
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                // Placeholder for Profile image (right now it's BabySteps logo)
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
                          blurRadius: 10
                      )
                    ],
                    image: const DecorationImage(
                        image: AssetImage('assets/BabyStepsLogo.png')
                    ),
                  ),
                ),
                
                // User's info box
                UserInfoCard(editing: editing, userName: currentUser.name, userEmail: currentUser.email),
                // UserInfoCard(
                //   label: '', 
                //   fields: [
                //     BuildInfoField(
                //       'Name', 
                //       [userProfile.name],
                //       const Icon(Icons.account_box), 
                //       editing, 
                //       updateUserName
                //     ),
                //     BuildInfoField(
                //       'Email', 
                //       [userProfile.email],
                //       const Icon(Icons.email), 
                //       editing, 
                //       updateUserEmail
                //     ),
                // ]),
                
                // Children's info boxes
                // for (Baby element in babyList)
                //   BabyBox(
                //       element.name,
                //       element.dob,
                //       element.caregivers ?? [],
                //       editing,
                //       updateBabyName,
                //       updateBabyDOB,
                //       element.collectionId
                //   ),

                // "Add Baby" button - only displays if profile page is in editing mode
                if (editing)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: ElevatedButton(
                      onPressed: createBaby,
                      style: blueButton(context),
                      child: const Text('Add Child', style: TextStyle(fontSize: 26)),
                    ),
                  ),

                // Edit button
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: editButtonClicked,
                    style: blueButton(context),
                    child: Text(editing ? 'Save' : 'Edit', style: const TextStyle(fontSize: 26)),
                  ),
                ),
                const SizedBox(height: 16),

                // Logout button
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      currentUser = UserProfile(name: "EmTestUser", email: "emtestuser@email.com", uid: "emTestUid", userDoc: "emTestUserDoc");
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
