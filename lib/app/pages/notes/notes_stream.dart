import 'package:babysteps/app/pages/notes/notes_card.dart';
import 'package:babysteps/app/pages/notes/notes_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

/// The widget that reads realtime Event updates.
class NotesStream extends StatefulWidget{
  const NotesStream({super.key});

  @override
  _NotesStreamState createState() => _NotesStreamState();
}

class _NotesStreamState extends State<NotesStream> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> eventStream = NoteDatabaseMethods().getNotesStream();
    
    return StreamBuilder<QuerySnapshot>(
      stream: eventStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        
        // An array of Note documents
        var noteDocs = snapshot.data!.docs;

        if(noteDocs.isEmpty) {
          return const Text("No notes");
        } 
        else {
          return ListView(
            shrinkWrap: true, // TODO We can make this a SizedBox and it will scroll by default. But, the box is not obviously scrollable.
            children: noteDocs
                .map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  
                  var docId = document.id;
                  return NotesCard(data['title'], docId, context: context);
                })
                .toList()
                .cast(),
          );
        }
      },
    );
  }
}