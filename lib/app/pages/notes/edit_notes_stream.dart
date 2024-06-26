import 'package:babysteps/app/pages/notes/notes.dart';
import 'package:babysteps/app/pages/notes/notes_database.dart';
import 'package:babysteps/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

/// The widget that reads realtime Event updates.
class EditNotesStream extends StatefulWidget {
  var docId;

  EditNotesStream(this.docId, {super.key});

  @override
  _EditNotesStreamState createState() => _EditNotesStreamState();
}

class _EditNotesStreamState extends State<EditNotesStream> {
  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot<Map<String, dynamic>>> eventStream =
        NoteDatabaseMethods().getSpecificNotesStream(
            widget.docId, currentUser.value!.currentBaby.value!.collectionId);

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: eventStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // The Note document
        var noteDoc = snapshot.data!;
        var docId = noteDoc.id;

        if (!noteDoc.exists) {
          return const Text("Error: This note does not exist.");
        } else {
          Map<String, dynamic> data = noteDoc.data()! as Map<String, dynamic>;

          return NotesPage(docId, data['title'], data['contents']);
        }
      },
    );
  }
}
