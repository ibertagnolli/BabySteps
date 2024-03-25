import 'package:babysteps/app/pages/calendar/calendar_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

/// The widget that reads realtime milestone updates.
class MilestoneStream extends StatefulWidget{
  DateTime selectedDay;
  MilestoneStream({required this.selectedDay, super.key});

  @override
  _MilestoneStreamState createState() => _MilestoneStreamState();
}

class _MilestoneStreamState extends State<MilestoneStream> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> milestoneStream = CalendarDatabaseMethods().getMilestoneStream(widget.selectedDay);

    return StreamBuilder<QuerySnapshot>(
      stream: milestoneStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        
        // An array of milestone documents
        var milestoneDocs = snapshot.data!.docs;

        if(milestoneDocs.isEmpty) {
          return const Text("No New Milestones today.");
        } 
        else {
                  return ListView(
            shrinkWrap: true, // TODO We can make this a SizedBox and it will scroll by default. But, the box is not obviously scrollable.
            children: milestoneDocs
                .map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return ListTile(                      
                      title: Row(
                        children: [Text(data['name']), 
                                   const Text(" on "), 
                                   Text(DateFormat('MM/dd/yyyy').format(data['dateTime'].toDate()))]
                      ),
                    );
                })
                .toList()
                .cast(),
          );
        }
      },
    );
  }
}