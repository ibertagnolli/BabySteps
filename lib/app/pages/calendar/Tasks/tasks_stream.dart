import 'package:babysteps/app/pages/calendar/Tasks/task_card.dart';
import 'package:babysteps/app/pages/calendar/Tasks/tasks_database.dart';
import 'package:babysteps/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:core';

FirebaseFirestore db = FirebaseFirestore.instance;

/// Displays list of reminder cards, or message stating there are no reminders
class TaskStream extends StatefulWidget {
  DateTime selectedDay;
  TaskStream({required this.selectedDay, super.key});
  

  @override
  _TaskStreamState createState() => _TaskStreamState();
}

class _TaskStreamState extends State<TaskStream> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> tasksStream = TasksDatabaseMethods()
        .getTasksStream(currentUser.value!.userDoc, widget.selectedDay); 

    return StreamBuilder<QuerySnapshot>(
      stream: tasksStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // An array of Reminder documents
        var taskDocs = snapshot.data!.docs;

        if (taskDocs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("No tasks today."),
          );
        } else {
          return ListView(
            physics: const NeverScrollableScrollPhysics(), // so the whole page scrolls, not just the reminders
            shrinkWrap:
                true, 
            children: taskDocs
                .map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  var docId = document.id;
                  return 
                    TaskCard(data['remindAbout'], data['reminderType'], data['dateTime'], data['notificationID'], data['completed'], docId, context: context);
                })
                .toList()
                .cast(),
          );
        }
      },
    );
  }
}
