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

        // An array of documents, but our query only returns an array of one document
        var lastWeightDoc = snapshot.data!.docs;

        DateTime date = lastWeightDoc[0]['date'].toDate();
        String dateStr = DateFormat('MM-dd hh:mm').format(date);
        String pounds = lastWeightDoc[0]['pounds'];
        String ounces = lastWeightDoc[0]['ounces'];

        // TODO update what we return!
        return Text(
          "$dateStr , $pounds , $ounces",
        );
      },
    );
  }
}
