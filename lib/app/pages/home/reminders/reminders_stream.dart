import 'package:babysteps/app/pages/home/reminders/reminders_database.dart';
import 'package:babysteps/app/pages/home/reminders/reminder_card.dart';
import 'package:babysteps/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:core';



FirebaseFirestore db = FirebaseFirestore.instance;

/// The widget that reads realtime Reminders updates.
class RemindersStream extends StatefulWidget {
  RemindersStream({super.key});

  @override
  _RemindersStreamState createState() => _RemindersStreamState();
}

class _RemindersStreamState extends State<RemindersStream> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> remindersStream = RemindersDatabaseMethods()
        .getRemindersStream(currentUser.value!.userDoc ); 

    return StreamBuilder<QuerySnapshot>(
      stream: remindersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // An array of Reminder documents
        var reminderDocs = snapshot.data!.docs;

        if (reminderDocs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Text("No reminders set."),
          );
        } else {
          return ListView(
            physics: const NeverScrollableScrollPhysics(), // so the whole page scrolls, not just the reminders
            shrinkWrap:
                true, 
            children: reminderDocs
                .map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  var docId = document.id;
                  return 
                    ReminderCard(data['remindAbout'], data['reminderType'], data['dateTime'], data['notificationID'], docId, context: context);
                })
                .toList()
                .cast(),
          );
        }
      },
    );
  }
}
