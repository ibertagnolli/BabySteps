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
  final Stream<QuerySnapshot> _weightStream = db.collection("Babies").doc("IYyV2hqR7omIgeA4r7zQ").collection("Weight").snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _weightStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text ('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['pounds']),
              // ounces: Text(data['ounces']),
              subtitle: Text(data['date']),
            );
          })
          .toList()
          .cast(),
        );
      },
    );
  }
}


/**
 * QUESTIONS
 * 
 * How to use the StreamBuilder widget?
 * https://firebase.google.com/docs/firestore/query-data/listen
 * 
 */