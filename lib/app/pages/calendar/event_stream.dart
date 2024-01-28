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
        var lastWeightDoc = snapshot.data!.docs;

        DateTime date = lastWeightDoc[0]['date'].toDate();
        String dateStr = DateFormat('MM-dd hh:mm').format(date);
        String pounds = lastWeightDoc[0]['pounds'];
        String ounces = lastWeightDoc[0]['ounces'];

        // Returns the FilledCard with read values for date, pounds, and ounces
        // updated in real time.
        return FilledCard(dateStr, "weight: $pounds lbs $ounces oz", Icon(Icons.scale));
      },
    );
  }
}