import 'package:babysteps/app/pages/home/home.dart';
import 'package:babysteps/app/pages/home/reminders/reminders_database.dart';
import 'package:babysteps/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

/// The widget that reads realtime reminder updates.
class EditReminderStream extends StatefulWidget {
  var docId;

  EditReminderStream(this.docId, {super.key});

  @override
  _EditReminderStreamState createState() => _EditReminderStreamState();
}

class _EditReminderStreamState extends State<EditReminderStream> {
  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot<Map<String, dynamic>>> reminderStream =
        RemindersDatabaseMethods().getSpecificReminderStream(
            widget.docId, currentUser.value!.currentBaby.value!.collectionId);

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: reminderStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // The Reminder document
        var reminderDoc = snapshot.data!;
        var docId = reminderDoc.id;

        if (!reminderDoc.exists) {
          return const Text("Error: This note does not exist.");
        } else {
          Map<String, dynamic> data = reminderDoc.data()! as Map<String, dynamic>;

          return Text("idek");
          //NotesPage(docId, data['title'], data['contents']);
        }
      },
    );
  }
}
