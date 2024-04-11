import 'dart:math';

import 'package:babysteps/app/pages/calendar/Tasks/tasks_database.dart';
import 'package:babysteps/app/pages/calendar/Tasks/tasks_widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:babysteps/app/pages/calendar/Events/notifications.dart';
import 'package:intl/intl.dart';
import 'package:babysteps/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

/// The widget that reads realtime reminder updates.
class EditTaskStream extends StatefulWidget {
  var docId;

  EditTaskStream(this.docId, {super.key});
  
  @override
  _EditTaskStreamState createState() => _EditTaskStreamState();
}

class _EditTaskStreamState extends State<EditTaskStream> {
  // The global key uniquely identifies the Form widget and allows
  // validation of the form.
  final _formKey = GlobalKey<FormState>();

  // Store user input for database upload
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController howManyController = TextEditingController();
  TimeOfDay reminderTime = TimeOfDay.now();
  int reminderType = 1;
  String timeUnit = "minutes";

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    dateController.dispose();
    timeController.dispose();
    howManyController.dispose();
    super.dispose();
  }

  // "in" reminder or "at" reminder, based on radio buttons
  _setReminderType(int selectedType)  {
    
    WidgetsBinding.instance.addPostFrameCallback((_){
      setState(() {
        reminderType = selectedType;
      });
    });
  }

  // minuts, hours, days, based on dropdown
  _setTimeUnit(String selectedUnit)  {
    
    WidgetsBinding.instance.addPostFrameCallback((_){
      setState(() {
        timeUnit = selectedUnit;
      });
    });
  }

  /// Updates a reminder entry in the Firestore database.
  updateReminder(int notificationID, bool completed) async {
    
    DateTime reminderDT; 
    DateTime now = DateTime.now();
    Map<String, dynamic> uploaddata = {};

    // Task without a reminder
    if (reminderType == 3) {
      uploaddata = {
        'remindAbout': nameController.text,
        'reminderType': "none",
        'dateTime': now,
        'timeLength': 0,
        'timeUnit': "--",
        'notificationID': -1,
        'completed': false,
      }; 
    }
    else {
      // remind "in" a certain amount of time
      if(reminderType == 1) {
        int timeInterval = int.parse(howManyController.text);
        if (timeUnit == "minutes") {
          int minutes = now.minute + timeInterval;
          reminderDT = DateTime(now.year, now.month, now.day,
          now.hour, minutes);
        }
        else if (timeUnit == "hours") {
          int hours = now.hour + timeInterval;
          reminderDT = DateTime(now.year, now.month, now.day,
          hours, now.minute);
        }
        else { // days
          int days = now.day + timeInterval;
          reminderDT = DateTime(now.year, now.month, days,
          now.hour, now.minute);
        }
      }
      // remind "at" certain time
      else {
        DateTime reminderDate = DateFormat("MM/dd/yyyy").parse(dateController.text);
        List<String> splitTime = timeController.text.split(' '); // format 2:00 PM
        List<String> splitHrMin = splitTime[0].split(':');
        String dayNight = splitTime[1];
        int hr = int.parse(splitHrMin[0]);
        if(dayNight == "PM") {
          hr += 12;
        }
        int min = int.parse(splitHrMin[1]);
        TimeOfDay reminderTime = TimeOfDay(hour: hr, minute: min);
        reminderDT = DateTime(reminderDate.year, reminderDate.month, reminderDate.day,
          reminderTime.hour, reminderTime.minute);
      }
      // Delete previous notification 
      NotificationService().deleteNotification(notificationID);
      // Schedule updated notification
      int newNotificationID = Random().nextInt(1000000);
      if(DateTime.now().isBefore(reminderDT)) {
        NotificationService().scheduleNotification(
              id: newNotificationID,
              title: nameController.text,
              body:
                  DateFormat("h:mma").format(reminderDT),
              scheduledNotificationDateTime: reminderDT);
      }

      // Write reminder data to database
      uploaddata = {
        'remindAbout': nameController.text,
        'reminderType': (reminderType == 1) ? "in" : "at",
        'dateTime': reminderDT,
        'timeLength': (howManyController.text.isNotEmpty) ? int.parse(howManyController.text) : -1,
        'timeUnit': (howManyController.text.isNotEmpty) ? timeUnit : "--",
        'notificationID': newNotificationID,
        'completed': completed,
      };
    }
    await TasksDatabaseMethods()
        .updateTask( widget.docId, uploaddata, currentUser.value!.userDoc);

    // Clear fields for next entry (not date)
    nameController.clear();
    howManyController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot<Map<String, dynamic>>> reminderStream =
        TasksDatabaseMethods().getSpecificReminderStream(
            widget.docId, currentUser.value!.userDoc);

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: reminderStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("");
        }

        // The Reminder document
        var reminderDoc = snapshot.data!;
        var docId = reminderDoc.id;
        if (!reminderDoc.exists) {
          return const Text("Error: This reminder does not exist.");
        } else {

          Map<String, dynamic> data = reminderDoc.data()! as Map<String, dynamic>;
          
          return IconButton(
              icon: const Icon(Icons.edit),
              // Dialog with reminder entry
              onPressed: () {

                // Populate the controllers
                nameController.text = data['remindAbout'];
                int initRadioButton;
                String initUnitSelection;
                if(data['reminderType'] == "in") {
                  _setReminderType(1);
                  initRadioButton = 1;
                  howManyController.text = data['timeLength'].toString();
                  initUnitSelection = data['timeUnit'];
                  _setTimeUnit(initUnitSelection);
                  dateController.text = DateFormat.yMd().format(DateTime.now());
                  timeController.text = TimeOfDay.now().format(context);
                }
                else if(data['reminderType'] == "at") { // "at" reminder
                  _setReminderType(2);
                  initRadioButton = 2;
                  reminderType = 2;
                  initUnitSelection = "minutes";
                  _setTimeUnit("minutes");
                  DateTime reminderDate = DateTime.fromMillisecondsSinceEpoch(data['dateTime'].seconds * 1000);
                  dateController.text = DateFormat.yMd().format(reminderDate);
                  TimeOfDay initTimeOfDay = TimeOfDay(hour: reminderDate.hour, minute: reminderDate.minute);
                  timeController.text = initTimeOfDay.format(context); 
                }
                else {
                  _setReminderType(3);
                  initRadioButton = 3;
                  reminderType = 3;
                  initUnitSelection = "none";
                  dateController.text = DateFormat.yMd().format(DateTime.now());
                  timeController.text = TimeOfDay.now().format(context);
                }

                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          scrollable: true,
                          title: const Text("Edit Reminder"),
                          content: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[

                                    NewTaskForm(nameController, howManyController, dateController, timeController, _setReminderType, _setTimeUnit, initUnitSelection, initRadioButton),

                                    // Submit button
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState!.validate()) {
                                              updateReminder(data['notificationID'], data['completed']);
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: const Text("Update")),
                                    )
                                  ],
                                )),
                          ));
                    });
              },
            );
        } 
      },
    );
  }
}


