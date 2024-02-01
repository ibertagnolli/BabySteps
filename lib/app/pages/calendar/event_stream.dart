import 'package:babysteps/app/pages/calendar/calendar_database.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

/// The widget that reads realtime Event updates.
class EventStream extends StatefulWidget{
  DateTime selectedDay;
  EventStream({required this.selectedDay, super.key});

  @override
  _EventStreamState createState() => _EventStreamState();
}

class _EventStreamState extends State<EventStream> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> eventStream = CalendarDatabaseMethods().getEventStream(widget.selectedDay);
    
    print("EventStream ${widget.selectedDay}");

    return StreamBuilder<QuerySnapshot>(
      stream: eventStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        
        // An array of Event documents
        var eventDocs = snapshot.data!.docs;

        if(eventDocs.isEmpty) {
          return const Text("No events today.");
        } 
        else {
          return ListView(
            shrinkWrap: true, // TODO We can make this a SizedBox and it will scroll by default. But, the box is not obviously scrollable.
            children: eventDocs
                .map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return ListTile(                      
                      title: Row(
                        children: [Text(data['name']), 
                                   const Text(" at "), 
                                   Text(DateFormat('hh:mm').format(data['dateTime'].toDate()))]
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