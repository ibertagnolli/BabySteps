import 'package:babysteps/app/pages/user/user_database.dart';
import 'package:babysteps/app/widgets/styles.dart';
import 'package:babysteps/main.dart';
import 'package:babysteps/model/baby.dart';
import 'package:babysteps/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:core';

import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AddBabyPage extends StatefulWidget {
  const AddBabyPage({super.key});

  @override
  State<AddBabyPage> createState() => _AddBabyPageState();
}

class _AddBabyPageState extends State<AddBabyPage> {
  User? user = FirebaseAuth.instance.currentUser;
  
  // Text field controllers
  TextEditingController dateController = TextEditingController(text: DateFormat.yMd().format(DateTime.now()));
  TextEditingController babyNameController = TextEditingController();

  // Keys for form validation
  final _mainSignUpPageKey = GlobalKey<FormState>();
  final _alertAddBabyKey = GlobalKey<FormState>();

  List<dynamic> babyCaregivers = [];
  String babyCollectionId = "";
  bool secondaryCaregiver = false;

  /// Connects the secondary caregiver to the baby
  void uploadDataSecondaryCaregiver() async {
    try {
      // Create the new user connected to the baby
      Map<String, dynamic> userData = {
        'baby': [babyCollectionId],
        'UID': FirebaseAuth.instance.currentUser?.uid,
      };
      UserDatabaseMethods().addUserWithBaby(userData);

      // Add the user to the baby's list of caregivers
      DocumentSnapshot snapshot = await UserDatabaseMethods().getBaby(babyCollectionId);
      Map<String, dynamic> doc = snapshot.data()! as Map<String, dynamic>;
      
      List<dynamic> caregivers = doc['Caregivers'];
      caregivers.add({
        'name': currentUser.name,
        'doc': currentUser.userDoc,
        'uid': currentUser.uid
      });
      await UserDatabaseMethods().updateBabyCaregiver(babyCollectionId, caregivers);

      // Update current user
      currentUser.babies.add(
        Baby(
          collectionId: babyCollectionId,
          dob: (doc['DOB'] as Timestamp).toDate(),
          name: doc['Name'],
          caregivers: caregivers as List<Map<String, String>>
        )
      );
    } catch (e) {
      print(
          'invalid code ${e.toString()}');
    }
  }

  /// Creates a new baby and adds it to the primary caregiver
  void uploadDataPrimaryCaregiver() async {
    // Create the new baby
    Map<String, dynamic> babyData = {
      'DOB': DateFormat.yMd().parse(dateController.text),
      'Name': babyNameController.text,
    };
    DocumentReference babyRef = await UserDatabaseMethods().addBaby(babyData);

    // Create the new user, connected to the baby
    Map<String, dynamic> userData = {
      'baby': [babyRef.id],
      'UID': FirebaseAuth.instance.currentUser?.uid,
    };
    await UserDatabaseMethods().addUserWithBaby(userData);

    // Update the current user
    currentUser.name = user?.displayName ?? '';
    currentUser.uid = user!.uid;
    List<Baby> babies = [];

    QuerySnapshot snapshot = await UserDatabaseMethods().getUser(user!.uid);
    var doc = snapshot.docs;
    if (doc.isNotEmpty) {
      List<dynamic> babyIds = doc[0]['baby'];
      for (String babyId in babyIds) {
        if (babyId != '') {
          DocumentSnapshot snapshot2 =
              await UserDatabaseMethods().getBaby(babyId);
          Map<String, dynamic> doc2 = snapshot2.data()! as Map<String, dynamic>;

          babies.add(Baby(
              collectionId: babyId,
              dob: (doc2['DOB'] as Timestamp).toDate(),
              name: doc2['Name'],
              caregivers: doc2['Caregivers']));
        }
      }
      currentUser.babies = babies;
    }
  }

  /// Shows a dialog box for User to input the code to add a baby
  void enterBabyCode() {
    TextEditingController babyCode = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column (
                  mainAxisSize: MainAxisSize.min, // Limit size of alert dialog
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text("Baby Code:"),
                    ),

                    // Form entry for baby code
                    Form(
                      key: _alertAddBabyKey,
                      child: TextFormField(
                        controller: babyCode,
                        maxLength: 20, // Size of a Baby Collection Id
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the baby code';
                          }
                          return null;
                        },
                      ),
                    ),

                    // Code submit button
                    ElevatedButton(
                      onPressed: () async {
                        if (_alertAddBabyKey.currentState!.validate()) {
                          try {
                            // Get Baby's info
                            DocumentSnapshot snapshot = await UserDatabaseMethods().getBaby(babyCode.text);
                            Map<String, dynamic> doc = snapshot.data()! as Map<String, dynamic>;

                            babyNameController.text = doc['Name'];
                            dateController.text = DateFormat.yMd().format(doc['DOB'].toDate());

                            // Save these values for database updates in uploadData()
                            babyCaregivers = doc['Caregivers'];
                            babyCollectionId = babyCode.text;
                            
                            secondaryCaregiver = true;
                            Navigator.pop(context);
                        } catch (e) {
                          print('invalid code ${e.toString()}');
                        }     
                      }        
                    },                
                    style: blueButton(context),
                    child: const Text('Add baby'),
                    ),
                ],)  
            )
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    // Nav Bar
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              
              // Logo
              SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset('assets/BabyStepsLogo.png',
                      fit: BoxFit.scaleDown)),
              
              // Welcome message
              Text(
                'Tell us about your baby',
                style: TextStyle(
                    fontSize: 30.0,
                    color: Theme.of(context).colorScheme.surface),
              ),
              Text(
                'This information can always be updated',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Theme.of(context).colorScheme.surface),
              ),
              
              // Form for user input
              Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _mainSignUpPageKey,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    
                      // Form field for Baby's name
                      TextFormField(
                        cursorColor: Theme.of(context).colorScheme.secondary,
                        controller: babyNameController,
                        maxLength: 25,
                        decoration: InputDecoration(
                          labelText: 'Baby\'s first name',
                          labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary,),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)),
                          focusColor: Theme.of(context).colorScheme.secondary,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the baby\'s name';
                          }
                          return null;
                        },
                      ),
                    
                      // Form field for Baby's DOB entry
                      // const Text('Date of birth:'),
                      TextFormField(
                        controller: dateController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today_rounded),
                          labelText: 'Date of birth:',
                        ),
                        onTap: () async {
                          // Don't show keyboard
                          FocusScope.of(context).requestFocus(FocusNode());

                          DateTime? pickeddate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2101));

                          if (pickeddate != null) {
                            setState(() {
                              dateController.text = DateFormat.yMd().format(pickeddate);
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a date';
                          }
                          return null;
                        },
                      ),

                      // Next button
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: FilledButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_mainSignUpPageKey.currentState!.validate()) {
                                if(secondaryCaregiver) {
                                  uploadDataSecondaryCaregiver();
                                } else {
                                  uploadDataPrimaryCaregiver();
                                }
                                context.go('/home');
                              }                              
                            },
                            style: FilledButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary),
                            child: Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            )),
                      ),

                      // Explain adding baby code
                      Text(
                        'Or click here to add a baby code',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Theme.of(context).colorScheme.surface),
                      ),

                      // Enter Code button
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: FilledButton(
                            onPressed: enterBabyCode,
                            style: FilledButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary),
                            child: Text(
                              'Enter Code',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            )),
                      ),
                    ],
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
