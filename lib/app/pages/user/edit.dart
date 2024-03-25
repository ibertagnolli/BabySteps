import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController babyNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

//TODO: populate textedits with current data
  Future<void> fetchUserInfo() async {
    if (FirebaseAuth.instance.currentUser != null) {
      try {
        final uid = FirebaseAuth.instance.currentUser!.uid;

        final userSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('UID', isEqualTo: uid)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          final userData = userSnapshot.docs.first.data();
          nameController.text = FirebaseAuth.instance.currentUser!.displayName!;
          emailController.text = FirebaseAuth.instance.currentUser!.email!;

          String babyId = userData['baby'];
          // Fetch baby document using babyId
          final babySnapshot = await FirebaseFirestore.instance
              .collection('Babies')
              .doc(babyId)
              .get();

          if (babySnapshot.exists) {
            final babyData = babySnapshot.data();
            babyNameController.text = babyData?['Name'];
            dobController.text = babyData?['DOB'];
          } else {
            print('Baby document not found for baby: $babyId');
          }
          dobController.text = userData['dateOfBirth'];
        }
      } catch (error) {
        print('Error fetching user information: $error');
      }
    }
  }

  //TODO:Save new information to the database
  void saveChanges() {
    // Perform saving changes to the backend/database here
    // Update the user's information with the new values
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildInputField('Name', nameController),
            buildInputField('Email', emailController),
            buildInputField('Baby Name', babyNameController),
            buildInputField('Date of Birth', dobController),
            SizedBox(height: 16),
            Expanded(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Align(
                      alignment: FractionalOffset.bottomRight,
                      child: ElevatedButton(
                        //TODO: connect to BE so when they save it adds note to DB
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.tertiary),
                          foregroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.onTertiary),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: const Text('Save Changes',
                            style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Align(
                      alignment: FractionalOffset.bottomLeft,
                      child: ElevatedButton(
                          onPressed: () => context.go('/login/signup/addBaby'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.tertiary),
                            foregroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.onTertiary),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Add Baby',
                            style: TextStyle(fontSize: 20),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.surface),
          ),
        ),
      ),
    );
  }
}
