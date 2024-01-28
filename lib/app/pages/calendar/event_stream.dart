import 'package:babysteps/app/pages/calendar/calendar_database.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

/// The widget that reads realtime weight updates for the FilledCard.
class EventStream extends StatefulWidget{
  DateTime selectedDay;
  EventStream({required this.selectedDay, super.key});

  @override
  _EventStreamState createState() => _EventStreamState();
}

class _EventStreamState extends State<EventStream> {
  @override
  Widget build(BuildContext context) {
    print("Selected Day ${widget.selectedDay}");
    final Stream<QuerySnapshot> _eventStream = CalendarDatabaseMethods().getEventStream(widget.selectedDay);

    return StreamBuilder<QuerySnapshot>(
      stream: _eventStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        
        // An array of Event documents
        // TODO account for empty array - day with no events
        var eventDocs = snapshot.data!.docs;

        DateTime date = eventDocs[0]['dateTime'].toDate();
        String dateStr = DateFormat('hh:mm').format(date);
        String name = eventDocs[0]['name'];

        /*
        WHERE EMILY LEFT OFF

        Data is being read! Need to update query to select by date, not just all the documents in the collection.
        When reading from the correct date, return ExpansionTiles to Calendar.dart.
        */

        return Text("Date: $dateStr, Name: $name");
      },
    );
  }
}