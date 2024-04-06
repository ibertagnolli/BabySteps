import 'package:babysteps/app/pages/home/reminders/reminders_database.dart';
import 'package:babysteps/app/pages/home/reminders/edit_reminder_stream.dart';
import 'package:babysteps/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:intl/intl.dart';

/// Each card shows a reminder on the home page
class ReminderCard extends StatelessWidget {
  final String name;
  final String reminderType;
  final Timestamp timestamp;
  final docId;
  final context; // TODO if we make this a Stateful widget, we'll have access to context outside of build()

  const ReminderCard(this.name, this.reminderType, this.timestamp, this.docId,
      {super.key, this.context}); // this.context

  /// Deletes the selected Reminder from the database
  Future<void> deleteReminder() async {
    await RemindersDatabaseMethods()
        .deleteReminder(docId, currentUser.value!.userDoc);
  }

  // /// Opens the Reminder for edits
  // void editReminder() {
  //   // Navigator.push(
  //   //   context,
  //   //   MaterialPageRoute(builder: (context) => EditRemindersStream(docId)),
  //   // );
  // }

  @override
  Widget build(BuildContext context) {

    DateTime reminderDate = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
    String reminderTime = DateFormat.jm().format(reminderDate);
    String reminderDay = DateFormat.Md().format(reminderDate);
    Duration timeDifference = reminderDate.difference(DateTime.now()); // reminderDate - now
    int timeDifferenceDays = timeDifference.inDays.abs();
    int timeDifferenceHours = timeDifference.inHours.abs() % 24;
    int timeDifferenceMin = timeDifference.inMinutes.abs() % 60;
    String timeDiffString = (((timeDifferenceDays) > 0 ? " $timeDifferenceDays days" : '') 
              + ((timeDifferenceHours) > 0 ? " $timeDifferenceHours hr" : '') 
              + ((timeDifferenceMin) > 0 ? " $timeDifferenceMin min" : '') );
    String remindIn = (reminderDate.isBefore(DateTime.now()) ? timeDiffString + " ago" : "in" + timeDiffString);

    return Card(
      color: (reminderDate.isBefore(DateTime.now())) ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.surface,
      child: InkWell(
        //onTap: () => editReminder(),
        splashColor: Theme.of(context).colorScheme.surface,
        child: SizedBox(
          width: 200,
          height: 80,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Reminder name
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ((reminderType == "in") ? remindIn
                      : "at $reminderDay, $reminderTime")
                    ),
                  ],
                ),
              ),
              const Expanded(
                  child: SizedBox(
                width: 30,
                height: 80,
              )),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Align(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Delete button
                      IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      // Dialog confirming user wants to delete the reminder
                                      return AlertDialog(
                                          title: Text(
                                              "Do you want to delete \"$name\"?"),
                                          actions: <Widget>[
                                            TextButton(
                                                child: const Text('Yes'),
                                                onPressed: () {
                                                  deleteReminder();
                                                  Navigator.of(context).pop();
                                                }),
                                            TextButton(
                                                child: const Text('No'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                })
                                          ]);
                                    })
                              }),

                      // Edit button
                      EditReminderStream(docId),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}