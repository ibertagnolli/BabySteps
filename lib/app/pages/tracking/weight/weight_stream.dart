import 'package:babysteps/app/pages/tracking/weight/weight_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class WeightStream extends StatefulWidget{
  @override
  _WeightStreamState createState() => _WeightStreamState();
}

class _WeightStreamState extends State<WeightStream> {
  final Stream<QuerySnapshot> _weightStream = db.collection("Babies").doc("IYyV2hqR7omIgeA4r7zQ").collection("Weight").orderBy('date', descending: true).limit(1).snapshots(); // TODO see if orderBy works. Can we just track realtime updates to this specific query? Not the collection in general?

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

        // IDEA: Return a widget with all the data values. Extract the data values as the individual strings for the FilledCard.
        // Access the most recently added document. Get its timestamp, pounds, and ounces.
        // FIRST: just return the timestamp
        // NEXT THING: test returning the Text widget with fresh read allocation!

        DateTime timestamp = DateTime.now();
        String pounds = "";
        String ounces = "";

        var test = snapshot.data!.docs.map((DocumentSnapshot document) { // TODO get the most recently added document -> taken care of by monitoring the specific query?
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

          timestamp = data['date'];
          pounds = data['pounds'];
          ounces = data['ounces'];
        }
        );

        String timestampStr = DateFormat('yyyy-MM-dd – hh:mm').format(timestamp);

        return Text(
          "$timestampStr , $pounds , $ounces",
        );
      },
    );
  }
}
