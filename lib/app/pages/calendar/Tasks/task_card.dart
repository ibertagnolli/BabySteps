import 'package:babysteps/app/pages/calendar/Tasks/edit_task_stream.dart';
import 'package:babysteps/app/pages/calendar/Tasks/tasks_database.dart';
import 'package:babysteps/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:babysteps/app/pages/calendar/Events/notifications.dart';
import 'package:intl/intl.dart';

/// Each card shows a reminder on the home page
class TaskCard extends StatelessWidget {
  final String name;
  final String reminderType;
  final Timestamp timestamp;
  final bool completed;
  final int notificationID;
  final docId;
  final context; 

  const TaskCard(this.name, this.reminderType, this.timestamp, this.notificationID, this.completed, this.docId,
      {super.key, this.context}); // this.context

  /// Deletes the selected Reminder from the database
  Future<void> deleteTask() async {

    // Delete notification 
    NotificationService().deleteNotification(notificationID);

    await TasksDatabaseMethods()
        .deleteTask(docId, currentUser.value!.userDoc);
  }

  @override
  Widget build(BuildContext context) {

    // Get all necessary info 
    DateTime reminderDate = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
    String reminderTime = DateFormat.jm().format(reminderDate);
    String reminderDay = DateFormat.Md().format(reminderDate);
    Duration timeDifference = reminderDate.difference(DateTime.now()); // reminderDate - now
    int timeDifferenceDays = timeDifference.inDays.abs();
    int timeDifferenceHours = timeDifference.inHours.abs() % 24;
    int timeDifferenceMin = timeDifference.inMinutes.abs() % 60;
    String timeDiffString = (((timeDifferenceDays) > 0 ? " $timeDifferenceDays days" : '') 
              + ((timeDifferenceHours) > 0 ? " $timeDifferenceHours hr" : '') 
              + (" $timeDifferenceMin min" ) );
    String remindIn = (reminderDate.isBefore(DateTime.now()) ? timeDiffString + " ago" : "in" + timeDiffString);

    bool colorTileRed = false;
    if (reminderType != "none" && reminderDate.isBefore(DateTime.now()) && !completed) {
      colorTileRed = true;
    }

    return Card(
      color: (colorTileRed) ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.surface,
      child: InkWell(
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
                    SizedBox(
                      width: 175,
                      child: Text(
                        name,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),

                    // Display timing info
                    if (reminderType != "none")
                      Text(
                        ((reminderType == "in") ? remindIn
                        : "at $reminderDay, $reminderTime")
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Align(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      // Edit button
                      EditTaskStream(docId),

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
                                                  deleteTask();
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

                      // Check box
                      Checkbox(
                        value: completed, 
                        onChanged: (bool? value) async {
                          // Write updated task data to database
                          Map<String, dynamic> updateData = {
                            'remindAbout': name,
                            'reminderType': reminderType,
                            'dateTime': timestamp,
                            'timeLength': -1,
                            'timeUnit': "--",
                            'notificationID': -1,
                            'completed': !completed,
                          };
                          await TasksDatabaseMethods().updateTask(
                              docId, updateData, currentUser.value!.userDoc);
                        },
                      ),
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