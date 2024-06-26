import 'package:babysteps/main.dart';
import 'package:babysteps/time_since.dart';
import 'package:babysteps/app/pages/tracking/diaper/diaper_database.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// The widget that reads realtime weight updates for the FilledCard.
class DiaperStream extends StatefulWidget {
  const DiaperStream({super.key});

  @override
  State<StatefulWidget> createState() => _DiaperStreamState();
}

class _DiaperStreamState extends State<DiaperStream> {
  final Stream<QuerySnapshot> _diaperStream = DiaperDatabaseMethods()
      .getStream(currentUser.value!.currentBaby.value!.collectionId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _diaperStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // An array of documents, but our query only returns an array of one document
        var lastDiaperDoc = snapshot.data!.docs;
        String timeSinceChange = "Never";
        String lastType = "";
        if (lastDiaperDoc.isNotEmpty) {
          DateTime date = lastDiaperDoc[0]['date'].toDate();
          timeSinceChange = getTimeSince(date);
          lastType = lastDiaperDoc[0]['type'];
        }

        // Returns the FilledCard with read values for date, pounds, and ounces
        // updated in real time.
        return FilledCard("last change: $timeSinceChange", "type: $lastType",
            const Icon(Icons.person_search_sharp));
      },
    );
  }
}
