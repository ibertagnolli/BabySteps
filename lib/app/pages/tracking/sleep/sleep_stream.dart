import 'package:babysteps/app/pages/tracking/sleep/sleep_database.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:babysteps/time_since.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// The widget that reads realtime weight updates for the FilledCard.
class SleepStream extends StatefulWidget {
  const SleepStream({super.key});

  @override
  State<StatefulWidget> createState() => _SleepStreamState();
}

class _SleepStreamState extends State<SleepStream> {
  final Stream<QuerySnapshot> _sleepStream = SleepDatabaseMethods().getStream();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _sleepStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // An array of documents, but our query only returns an array of one document
        var lastSleepDoc = snapshot.data!.docs;

        DateTime date = lastSleepDoc[0]['date'].toDate();
        String dateStr = getTimeSince(date);
        String length = lastSleepDoc[0]['length'];

        // Returns the FilledCard with read values for date, pounds, and ounces
        // updated in real time.
        return FilledCard("last nap: $dateStr", "sleep: $length minutes",
            Icon(Icons.person_search_sharp));
      },
    );
  }
}
