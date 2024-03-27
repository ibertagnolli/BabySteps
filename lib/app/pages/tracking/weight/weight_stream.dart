import 'package:babysteps/main.dart';
import 'package:babysteps/time_since.dart';
import 'package:babysteps/app/pages/tracking/weight/weight_database.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// The widget that reads realtime weight updates for the FilledCard.
class WeightStream extends StatefulWidget {
  const WeightStream({super.key});

  @override
  State<StatefulWidget> createState() => _WeightStreamState();
}

class _WeightStreamState extends State<WeightStream> {
  final Stream<QuerySnapshot> _weightStream = WeightDatabaseMethods()
      .getStream(currentUser.value!.currentBaby.value!.collectionId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _weightStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // An array of documents, but our query only returns an array of one document
        var lastWeightDoc = snapshot.data!.docs;

        String dateStr = 'Never';
        String pounds = "";
        String ounces = "";

        if (lastWeightDoc.isNotEmpty) {
          DateTime date = lastWeightDoc[0]['date'].toDate();
          dateStr = getTimeSince(date);
          pounds = "${lastWeightDoc[0]['pounds']} lbs";
          ounces = "${lastWeightDoc[0]['ounces']} oz";
        }

        // Returns the FilledCard with read values for date, pounds, and ounces
        // updated in real time.
        return FilledCard("last weight: $dateStr", "weight: $pounds $ounces",
            const Icon(Icons.scale));
      },
    );
  }
}
