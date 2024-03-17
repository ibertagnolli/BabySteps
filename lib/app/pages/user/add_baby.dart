import 'package:babysteps/app/pages/user/user_database.dart';
import 'package:babysteps/app/widgets/styles.dart';
import 'package:babysteps/main.dart';
import 'package:babysteps/model/baby.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  TextEditingController date = TextEditingController(text: DateFormat.yMd().format(DateTime.now()));
  TextEditingController babyName = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  // The global key uniquely identifies the Form widget and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  /// Creates a new primary user associated with a new baby
  uploadFirstBaby() async {
    // Add the baby to the DB
    Map<String, dynamic> uploaddata = {
      'DOB': DateFormat.yMd().parse(date.text),
      'Name': babyName.text,
      'PrimaryCaregiverUID': user?.uid,
      'Caregivers': [],
    };
    DocumentReference babyRef = await UserDatabaseMethods().addBaby(uploaddata);

    // Add the primary user to the DB (user is currently only in Auth)
    Map<String, dynamic> userData = {
      'baby': [babyRef.id],
      'UID': user?.uid,
    };
    await UserDatabaseMethods().addBabyToNewUser(userData);

    // Update currentUser
    currentUser.name = user?.displayName ?? '';
    currentUser.uid = user!.uid;
    currentUser.email = user!.email;
    
    List<Baby> babies = [];
    QuerySnapshot snapshot = await UserDatabaseMethods().getUser(user!.uid);
    var doc = snapshot.docs;
    if (doc.isNotEmpty) {
      List<dynamic> babyIds = doc[0]['baby'];
      for (String babyId in babyIds) {
        if (babyId != '') {
          DocumentSnapshot snapshot2 = await UserDatabaseMethods().getBaby(babyId);
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

  /// Creates a new caregiver user associated with an existing baby
  uploadBabyToCaregiver(TextEditingController babyCode) async {
    // Update currentUser
    currentUser.name = user?.displayName ?? '';
    currentUser.uid = user!.uid;
    currentUser.email = user!.email;

    try {
      // Create the caregiver user associated with existing baby
      Map<String, dynamic> userData = {
        'baby': [babyCode.text],
        'UID': currentUser.uid,
      };
      UserDatabaseMethods().addBabyToNewUser(userData);

      // Now that the caregiver user has been created, update currentUser's userDoc
      QuerySnapshot userSnapshot = await UserDatabaseMethods().getUser(user!.uid);
      var userDoc = userSnapshot.docs;
      currentUser.userDoc = userDoc[0].id;

      // Add the caregiver user to the baby's list of caregivers
      DocumentSnapshot snapshot = await UserDatabaseMethods().getBaby(babyCode.text);
      Map<String, dynamic> doc = snapshot.data()! as Map<String, dynamic>;
      List<dynamic> caregivers = doc['Caregivers'];
      caregivers.add({
        'name': currentUser.name,
        'doc': currentUser.userDoc,
        'uid': currentUser.uid
      });
      await UserDatabaseMethods().updateBabyCaregiver(babyCode.text, caregivers);
      
      // Finish updating currentUser with their updated list of babies
      List<Baby> babies = [];
      if (userDoc.isNotEmpty) {
        List<dynamic> babyIds = userDoc[0]['baby'];
        for (String babyId in babyIds) {
          if (babyId != '') {
            DocumentSnapshot snapshot2 = await UserDatabaseMethods().getBaby(babyId);
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
    } catch (e) {
      print('invalid code ${e.toString()}');
    }
  }

  /// Shows the dialog box where users can add a baby via an add code
  void showBabyAddCodeDialog(TextEditingController babyCode){
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
                        uploadBabyToCaregiver(babyCode);
                        context.go('/home');
                      },
                      style: blueButton(context),
                      child: const Text('Add baby'),
                    ),
                  ],
                )));
      });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController babyCode = TextEditingController();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              
              // Header logo and informational text
              SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset('assets/BabyStepsLogo.png',
                      fit: BoxFit.scaleDown)),
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
              
              // Form fields
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Form(
                  key: _formKey,
                  child: Column( children: <Widget> [

                    // Baby's name field
                    TextFormField(
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      controller: babyName,
                      decoration: InputDecoration(
                        labelText: 'Baby\'s first name',
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary)),
                        focusColor: Theme.of(context).colorScheme.secondary,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                            return 'Please enter the baby\'s name';
                          }
                        return null;
                      }
                    ),

                    // Baby's DOB field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Date of birth:'),
                        TextFormField(
                          controller: date,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_today_rounded),
                          ),
                          onTap: () async {
                            // Don't show keyboard
                            FocusScope.of(context).requestFocus(new FocusNode());

                            DateTime? pickeddate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2101));

                            if (pickeddate != null) {
                              setState(() {
                                date.text = DateFormat.yMd().format(pickeddate);
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
                      ],
                    ),

                    // Next button submits the form and adds the baby
                    FilledButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          uploadFirstBaby();
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
                      )
                    ),

                    // Text sectioning baby add code section
                    Text(
                      'Or click here to add a baby code',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Theme.of(context).colorScheme.surface),
                    ),

                    // Button to add baby with code
                    FilledButton(
                      onPressed: () {
                        showBabyAddCodeDialog(babyCode);                      
                      },
                      style: FilledButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary),
                      child: Text(
                        'Enter Code',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      )
                    ),
                  ],),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
