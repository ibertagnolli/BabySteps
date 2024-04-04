import 'package:babysteps/app/widgets/stopwatch.dart';
import 'package:babysteps/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/history_widgets.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// DIAPER

class DiaperDiarrheaStream extends StatefulWidget {
  const DiaperDiarrheaStream({super.key});

  @override
  State<StatefulWidget> createState() => _DiaperDiarrheaStreamState();
}

class _DiaperDiarrheaStreamState extends State<DiaperDiarrheaStream> {
  final Stream<QuerySnapshot> _diaperDiarrheaStream = db
      .collection("Babies")
      .doc(currentUser.value!.currentBaby.value!.collectionId)
      .collection("Diaper")
      .orderBy('date', descending: true)
      .where("diarrhea", isEqualTo: true)
      .limit(10)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _diaperDiarrheaStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // An array of documents
        var allDiaperDocs = snapshot.data!.docs;

        // Tracks entry date:number of entries for that date
        Map<DateTime, double> entries = {};

        // Go through all docs
        for (var doc in allDiaperDocs) {
          DateTime date = doc['date'].toDate();
          var month = date.month;
          var day = date.day;
          var year = date.year;

          // Add one to the number of entries for that date, or set it to 1 if there were none
          entries.update(DateTime(year, month, day, 0), (v) => v + 1,
              ifAbsent: () => 1);
        }

        // Make a graph with the retrieved data
        return TimeSeriesWidget(
            entries, "Recent Diarrhea", "Number of Diarrhea Diapers");
      },
    );
  }
}
