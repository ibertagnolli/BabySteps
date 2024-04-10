import 'dart:math';

import 'package:babysteps/app/pages/calendar/Tasks/tasks_database.dart';
import 'package:babysteps/app/pages/calendar/Tasks/tasks_widgets.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:babysteps/app/pages/home/reminders/reminders_database.dart';
import 'package:babysteps/app/pages/home/reminders/reminders_widgets.dart';
import 'package:babysteps/app/pages/calendar/Events/notifications.dart';
import 'dart:core';

// The widget that adds a new reminder.
class AddTaskButton extends StatefulWidget {
  AddTaskButton({super.key});

  @override
  State<StatefulWidget> createState() => _AddTaskButtonState();
}

/// Stores the mutable data that can change over the lifetime of the AddReminderButton.
class _AddTaskButtonState extends State<AddTaskButton> {
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

  // When radiobutton used to change remindertype, fix the state
  _setReminderType(int selectedType)  {
    WidgetsBinding.instance.addPostFrameCallback((_){
      setState(() {
        reminderType = selectedType;
      });
    });
  }

  // When dropdown used to change time unit, fix the state
  _setTimeUnit(String selectedUnit)  {
    WidgetsBinding.instance.addPostFrameCallback((_){
      setState(() {
        timeUnit = selectedUnit;
      });
    });
  }

  /// Saves a new reminder entry in the Firestore database.
  saveNewTask() async {
    DateTime reminderDT; 
    DateTime now = DateTime.now();

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

    // Schedule notification as long as reminder date is in the future
    int notificationID = Random().nextInt(1000000);
    if(DateTime.now().isBefore(reminderDT)) {
      NotificationService().scheduleNotification(
              id: notificationID,
              title: nameController.text,
              body:
                  DateFormat("h:mma").format(reminderDT),
              scheduledNotificationDateTime: reminderDT);
    }
    // Write reminder data to database
    Map<String, dynamic> uploaddata = {
      'remindAbout': nameController.text,
      'reminderType': (reminderType == 1) ? "in" : "at",
      'dateTime': reminderDT,
      'timeLength': (howManyController.text.isNotEmpty) ? int.parse(howManyController.text) : -1,
      'timeUnit': (howManyController.text.isNotEmpty) ? timeUnit : "--",
      'notificationID': notificationID,
    };
    await TasksDatabaseMethods()
        .addTask(uploaddata, currentUser.value!.userDoc);

    // Clear fields for next entry (not date)
    nameController.clear();
    howManyController.clear();
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      // Add Reminder Button
      width: 160.0,
      height: 40.0,
      child: ElevatedButton(
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
        child: const Text('Add Task'),
        // Dialog with reminder entry
        onPressed: () {
          // Populate the controllers
          dateController.text = DateFormat.yMd().format(DateTime.now());
          timeController.text = TimeOfDay.now().format(context);
          _setTimeUnit("minutes");
          _setReminderType(1);
          
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    scrollable: true,
                    title: const Text("New Task"),
                    content: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              
                              NewTaskForm(nameController, howManyController, dateController, timeController, _setReminderType, _setTimeUnit, "minutes", 1),
                              
                              // Submit button
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        saveNewTask();
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text("Submit")),
                              )
                            ],
                          )),
                    ));
              });
        },
      ),
    );
  }
}


