import 'package:babysteps/app/pages/tracking/feeding/bottleFeeding.dart';
import 'package:babysteps/app/pages/tracking/feeding/feeding_database.dart';
import 'package:babysteps/app/pages/tracking/sleep/sleep_database.dart';
import 'package:babysteps/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

/// The widget that adds a bottle.
class AddPreviousSleepCard extends StatefulWidget {
  const AddPreviousSleepCard({super.key});

  @override
  State<StatefulWidget> createState() => _AddPreviousSleepCardState();
}

/// Stores the mutable data that can change over the lifetime of the AddWeightCard.
class _AddPreviousSleepCardState extends State<AddPreviousSleepCard> {
  String activeButton = "Breast milk";

  // The global key uniquely identifies the Form widget and allows
  // validation of the form.
  final _formKey = GlobalKey<FormState>();

  TextEditingController minutes = TextEditingController();
  TextEditingController hours = TextEditingController();
  TextEditingController date = TextEditingController(
      text: DateFormat("MM/dd/yyyy hh:mm a").format(DateTime
          .now()));

  
  // Upload sleep entry into database
  uploadData() async {
    DateTime savedDate = DateFormat("MM/dd/yyyy hh:mm a").parse(date.text);
    
    String savedMins = minutes.text;
    int tempMins = int.parse(savedMins);
    if (tempMins < 10) {
      savedMins = "0$tempMins";
    }
    else {
      savedMins = "$tempMins";
    }

    String savedHours = hours.text;
    int tempHrs = int.parse(savedHours);
    if (tempHrs < 10) {
      savedHours = "0$tempHrs";
    }
    else {
      savedHours = "$tempHrs";
    }

    Map<String, dynamic> uploaddata = {
      'length': "$savedHours:$savedMins:00",
      'active': false,
      'date': savedDate,
    };

    await SleepDatabaseMethods().addSleepEntry(
        uploaddata, currentUser.value!.currentBaby.value!.collectionId);

    minutes.clear();
    hours.clear();
    date.text = DateFormat("MM/dd/yyyy hh:mm a").format(DateTime.now());
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    minutes.dispose();
    date.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        backgroundColor: Theme.of(context).colorScheme.surface,
        collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Add Previous Sleep',
            style: TextStyle(
                fontSize: 25,
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold)),
        initiallyExpanded: false,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(children: <Widget>[

                // Minutes
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            controller: hours,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter hours slept';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Text('hours',
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.onSurface)
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            controller: minutes,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter minutes slept';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Text('minutes',
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.onSurface)
                      ),
                    ],
                  ),
                ),

                // Second row: Date entry
                TextFormField(
                  controller: date,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today_rounded),
                  ),
                  onTap: () async {
                    await showCupertinoModalPopup<void>(
                      context: context,
                      builder: (_) {
                        final size = MediaQuery.of(context).size;

                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          height: size.height * 0.27,
                          child: CupertinoDatePicker(
                            maximumDate:
                                DateTime.now().add(const Duration(seconds: 30)),
                            mode: CupertinoDatePickerMode.dateAndTime,
                            onDateTimeChanged: (value) {
                              setState(() {
                                date.text = DateFormat("MM/dd/yyyy hh:mm a")
                                    .format(value);
                              });
                            },
                          ),
                        );
                      },
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a date';
                    }

                    // ERROR -> THIS ISN'T WORKING!!!
                    // NOTE: If user picks a date after current date, it reverts to the previously picked date.
                    // The entry field reflects this. No error checking, but doesn't let user input invalid data.

                    return null;
                  },
                  // Don't show the keyboard
                  showCursor: true,
                  readOnly: true,
                ),

                // Third row: Submit button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        uploadData();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.tertiary),
                      foregroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.onTertiary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: const Text('Save Sleep'),
                  ),
                ),
              ]),
            ),
          )
        ]);
  }
}