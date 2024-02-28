import 'package:babysteps/app/pages/user/user_widgets/baby_info_card.dart';
import 'package:babysteps/app/pages/user/user_widgets/user_info_card.dart';
import 'package:babysteps/app/widgets/styles.dart';
import 'package:babysteps/main.dart';
import 'package:babysteps/model/baby.dart';
import 'package:babysteps/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // UserProfile userProfile = currentUser;
  List<Baby> babyList = currentUser.babies;

  // True when User is editing their profile
  bool editing = false;

  // Controllers for form fields
  TextEditingController userNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController babyDOBController = TextEditingController();
  TextEditingController babyNameController = TextEditingController();
  TextEditingController caregiversController = TextEditingController();

/// Enters Edit mode if "Edit" button was clicked from Display mode.
/// Saves updated data if "Save" button was clicked from Edit mode.
  void editOrSaveButtonClicked() async {
    if (editing) {
      // Update the User's Info
      await FirebaseAuth.instance.currentUser!.updateDisplayName(userNameController.text); // TODO this isn't updating User's name
      currentUser.name = userNameController.text;

      // await FirebaseAuth.instance.currentUser?.verifyBeforeUpdateEmail(userEmailController.text);


      // EMILY LEFT OFF HERE
      // User updates aren't reflected in DB. Maybe move on and get baby FE and DB connected. Probably easier than User's DB.
      
      // List<String> babyIds = [];

      // Update each baby's info
      // for (Baby baby in updatedUser.babies) {
      //   babyIds.add(baby.collectionId);
      //   await UserDatabaseMethods().updateBaby(
      //       baby.collectionId,
      //       baby.name,
      //       baby.dob
      //   );
      // }

      // Update User's list of connected babies, in case they added a baby
      // await UserDatabaseMethods().updateUserBabies(updatedUser.userDoc, babyIds);
    }
    
    // Update the page to toggle between Editing mode and Display mode
    setState(() {
      editing = !editing;
    });
  }


  // The global key uniquely identifies the Form widget and allows validation of the form.
  final _userFormKey = GlobalKey<FormState>();
  final _babyFormKey = GlobalKey<FormState>();

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
                UserInfoCard(
                  editing: editing, 
                  userName: currentUser.name, 
                  userEmail: currentUser.email, 
                  formKey: _userFormKey,
                  userNameController: userNameController,
                  userEmailController: userEmailController,
                ),

                // Children's info boxes
                for (Baby element in babyList)
                  BabyInfoCard(
                      babyName: element.name,
                      babyDOB: element.dob,
                      babyId: element.collectionId,
                      caregivers: element.caregivers ?? [],
                      editing: editing,
                      formKey: _babyFormKey,
                      babyDOBController: babyDOBController,
                      babyNameController: babyNameController,
                      caregiversController: caregiversController,
                  ),

                // "Add Baby" button - only displays if profile page is in editing mode
                if (editing)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/login/signup/addBaby');
                      },
                      style: blueButton(context),
                      child: const Text('Add Child', style: TextStyle(fontSize: 26)),
                    ),
                  ),

                // Edit/Save button
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_userFormKey.currentState!.validate() && _babyFormKey.currentState!.validate()) {
                        editOrSaveButtonClicked();
                      }
                    },
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
                      currentUser = UserProfile(name: "FIX", email: "FIX", uid: "FIX", userDoc: "FIX"); // TODO try nulls
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
