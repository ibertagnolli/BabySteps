import 'package:babysteps/app/pages/home/reminders/reminders_database.dart';
import 'package:babysteps/app/pages/home/reminders/reminder_card.dart';
import 'package:babysteps/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:core';


FirebaseFirestore db = FirebaseFirestore.instance;

/// The widget that reads realtime Reminders updates.
class RemindersStream extends StatefulWidget {
  DateTime selectedDay;
  RemindersStream({required this.selectedDay, super.key});

  @override
  _RemindersStreamState createState() => _RemindersStreamState();
}

class _RemindersStreamState extends State<RemindersStream> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> remindersStream = RemindersDatabaseMethods()
        .getRemindersStream(widget.selectedDay, 'TYrhEVcdFGtEcbW5U6OL'); //*****TODO: currentUser.value!.userDoc  

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
          return const Text("No reminders set.");
        } else {
          return ListView(
            shrinkWrap:
                true, // TODO We can make this a SizedBox and it will scroll by default. But, the box is not obviously scrollable.
            children: reminderDocs
                .map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  var docId = document.id;
                  return 
                    ReminderCard(data['name'], docId, context: context);
                  // CheckboxListTile(
                  //   // TODO add this back if we want Tasks to have associated times
                  //   // title: Row(
                  //   //   children: [Text(data['name']),
                  //   //              const Text(" at "),
                  //   //              Text(DateFormat('hh:mm').format(data['dateTime'].toDate()))]
                  //   // ),
                  //   title: Text(data['name']),
                  //   value: data['completed'],
                  //   onChanged: (bool? value) async {
                  //     // Write updated reminder data to database
                  //     Map<String, dynamic> updateData = {
                  //       'name': data['name'],
                  //       'dateTime': data['dateTime'],
                  //       'completed': !data['completed'],
                  //     };
                  //     await RemindersDatabaseMethods().updateReminder(
                  //         docId, updateData, currentUser.value!.userDoc);
                  //   },
                  // );
                })
                .toList()
                .cast(),
          );
        }
      },
    );
  }
}
