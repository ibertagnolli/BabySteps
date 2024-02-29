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
  TextEditingController date =
      TextEditingController(text: DateFormat.yMd().format(DateTime.now()));
  TextEditingController babyName = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  uploadData() async {
    Map<String, dynamic> uploaddata = {
      'DOB': DateFormat.yMd().parse(date.text),
      'Name': babyName.text,
    };
    DocumentReference babyRef = await UserDatabaseMethods().addBaby(uploaddata);

    Map<String, dynamic> userData = {
      'baby': [babyRef.id],
      'UID': FirebaseAuth.instance.currentUser?.uid,
    };

    await UserDatabaseMethods().addBabyToUser(userData);

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
              Padding(
                padding: EdgeInsets.all(16),
                child: TextField(
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
                ),
              ),
              // Second row: Date entry
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date of birth:'),
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
              ),

              Padding(
                padding: EdgeInsets.all(16),
                child: FilledButton(
                    onPressed: () {
                      uploadData();
                      context.go('/tracking');
                      // context.go('/home');
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
              Text(
                'Or click here to add a baby code',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Theme.of(context).colorScheme.surface),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: FilledButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                                child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("Baby Code:"),
                                        TextField(
                                          controller: babyCode,
                                        ),
                                        SizedBox(height: 8),
                                        ElevatedButton(
                                          onPressed: () async {
                                            //TODO: make sure baby is actually in database

                                            try {
                                              Map<String, dynamic> userData = {
                                                'baby': [babyCode.text],
                                                'UID': FirebaseAuth
                                                    .instance.currentUser?.uid,
                                              };
                                              UserDatabaseMethods()
                                                  .addBabyToUser(userData);

                                              DocumentSnapshot snapshot =
                                                  await UserDatabaseMethods()
                                                      .getBaby(babyCode.text);
                                              Map<String, dynamic> doc =
                                                  snapshot.data()!
                                                      as Map<String, dynamic>;

                                              List<dynamic> caregivers =
                                                  doc['Caregivers'];

                                              caregivers.add({
                                                'name': currentUser.name,
                                                'doc': currentUser.userDoc,
                                                'uid': currentUser.uid
                                              });

                                              await UserDatabaseMethods()
                                                  .updateBabyCaregiver(
                                                      babyCode.text,
                                                      caregivers);

                                              currentUser.babies.add(Baby(
                                                  collectionId: babyCode.text,
                                                  dob: (doc['DOB'] as Timestamp)
                                                      .toDate(),
                                                  name: doc['Name'],
                                                  caregivers: caregivers
                                                      as List<
                                                          Map<String,
                                                              String>>));
                                              context.go('/tracking');
                                              // context.go('/home');
                                            } catch (e) {
                                              print(
                                                  'invalid code ${e.toString()}');
                                            }
                                          },
                                          style: blueButton(context),
                                          child: const Text('Add baby'),
                                        ),
                                      ],
                                    )));
                          });
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
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
