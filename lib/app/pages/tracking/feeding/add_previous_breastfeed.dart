import 'package:babysteps/app/pages/tracking/feeding/feeding_database.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

/// The widget that adds a bottle.
class AddPreviousBreastfeedCard extends StatefulWidget {
  const AddPreviousBreastfeedCard({super.key});

  @override
  State<StatefulWidget> createState() => _AddPreviousBreastfeedCardState();
}

/// Stores the mutable data that can change over the lifetime of the AddWeightCard.
class _AddPreviousBreastfeedCardState extends State<AddPreviousBreastfeedCard> {
  String activeButton = "Breast milk";

  // The global key uniquely identifies the Form widget and allows
  // validation of the form.
  final _formKey = GlobalKey<FormState>();

  TextEditingController leftMinutes = TextEditingController();
  TextEditingController rightMinutes = TextEditingController();
  TextEditingController date = TextEditingController(
      text: DateFormat("MM/dd/yyyy hh:mm a").format(DateTime
          .now()));

  
  //Upload the original data, this will be called once the session is started
  uploadData() async {
    DateTime savedDate = DateFormat("MM/dd/yyyy hh:mm a").parse(date.text);
    String savedLeftMins = leftMinutes.text;
    int leftMins = int.parse(savedLeftMins) * 60000; // convert minutes to ms
    String savedRightMins = rightMinutes.text;
    int rightMins = int.parse(savedRightMins) * 60000; // convert minutes to ms

    Map<String, dynamic> leftSideData = {
      'active': false,
      'duration': leftMins,
      'lastStart': "",
    };

    Map<String, dynamic> rightSideData = {
      'active': false,
      'duration': rightMins,
      'lastStart': "",
    };

    Map<String, dynamic> side = {
      'latest': "",
      'left': leftSideData,
      'right': rightSideData,
      'type': "BreastFeeding",
    };

    Map<String, dynamic> uploaddata = {
      'type': 'BreastFeeding',
      'side': side,
      'length': leftMins + rightMins,
      'active': false,
      'ounces': '--',
      'date': savedDate,
    };

    await FeedingDatabaseMethods().addFeedingEntry(
        uploaddata, currentUser.value!.currentBaby.value!.collectionId);

    leftMinutes.clear();
    rightMinutes.clear();
    date.text = DateFormat("MM/dd/yyyy hh:mm a").format(DateTime.now());
  }

  void bottleTypeClicked(String type) {
    setState(() {
      activeButton = type;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    leftMinutes.dispose();
    date.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        backgroundColor: Theme.of(context).colorScheme.surface,
        collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Add Previous Feed',
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

                // Left minutes
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: <Widget>[
                      // Pounds input
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            controller: leftMinutes,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter minutes fed on left side';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Text('mins on left side   ', // Spaces to make aligned with right text
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.onSurface)),
                    ],
                  ),
                ),

                // Right minutes
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: <Widget>[
                      // Pounds input
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            controller: rightMinutes,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter minutes fed on right side';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Text('mins on right side',
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.onSurface)),
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
                    child: const Text('Save Feed'),
                  ),
                ),
              ]),
            ),
          )
        ]);
  }
}
