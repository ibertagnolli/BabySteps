import 'package:babysteps/app/pages/calendar/Events/notifications.dart';
import 'package:babysteps/app/pages/tracking/feeding/bottleFeeding.dart';
import 'package:babysteps/app/pages/tracking/feeding/feeding_database.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

/// The widget that adds a bottle.
class AddBottleCard extends StatefulWidget {
  const AddBottleCard({super.key});

  @override
  State<StatefulWidget> createState() => _AddBottleCardState();
}

/// Stores the mutable data that can change over the lifetime of the AddWeightCard.
class _AddBottleCardState extends State<AddBottleCard> {
  String activeButton = "Breast milk";

  // The global key uniquely identifies the Form widget and allows
  // validation of the form.
  final _formKey = GlobalKey<FormState>();

  TextEditingController ounces = TextEditingController();
  TextEditingController date = TextEditingController(
      text: DateFormat("MM/dd/yyyy hh:mm a").format(DateTime
          .now())); // TODO is 24hr time ok? this is hard-coded, so we would need a bool if user can customize it

  uploadData() async {
    DateTime savedDate = DateFormat("MM/dd/yyyy hh:mm a").parse(date.text);
    String savedOz = ounces.text;

  
    Map<String, dynamic> uploaddata = {
      'type': 'Bottle',
      'side': '--',
      'length': '--',
      'bottleType': activeButton,
      'ounces': savedOz,
      'active': false,
      'date': savedDate,
    };

    await FeedingDatabaseMethods().addFeedingEntry(
        uploaddata,
        currentUser.value!.currentBaby.value!
            .collectionId); //We have ensured currentUser has been assigned and current baby is not null before calling add_bottle_card

    ounces.clear();
    date.text = DateFormat("MM/dd/yyyy hh:mm a").format(DateTime.now());


    //Schedule notification for reminder in 2 hours 
    var today = DateTime.now();
    var twoHours = today.hour + 2;
     NotificationService().scheduleNotification(
            id: 0,
            title: "Bottlefeeding Reminder",
            body: "Its been 2 hours since you last fed ${currentUser.value?.currentBaby.value?.name}"
                '$twoHours:${today.minute}',
            scheduledNotificationDateTime: DateTime(
                today.year,
                today.month,
                today.day,
                twoHours,
                today.minute));
  
  }

  void bottleTypeClicked(String type) {
    setState(() {
      activeButton = type;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    ounces.dispose();
    date.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        backgroundColor: Theme.of(context).colorScheme.surface,
        collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Add Bottle',
            style: TextStyle(
                fontSize: 25,
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold)),
        initiallyExpanded: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(children: <Widget>[
                // Buttons for bottle type
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: BottleTypeButton(
                          'Breast milk',
                          activeButton.contains("Breast milk"),
                          bottleTypeClicked),
                    ),
                    Expanded(
                        child: BottleTypeButton(
                            'Formula',
                            activeButton.contains("Formula"),
                            bottleTypeClicked))
                  ],
                ),
                // First row: Weight inputs
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: <Widget>[
                      // Pounds input
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            controller: ounces,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter ounces of milk';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Text('ounces',
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
                    child: const Text('Save Bottle'),
                  ),
                ),
              ]),
            ),
          )
        ]);
  }
}
