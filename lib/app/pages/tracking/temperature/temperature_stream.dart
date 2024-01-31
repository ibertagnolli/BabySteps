import 'package:babysteps/app/pages/tracking/temperature/temperature_database.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

/// The widget that reads realtime temperature updates for the FilledCard.
class TemperatureStream extends StatefulWidget{
  @override
  _TemperatureStreamState createState() => _TemperatureStreamState();
}

class _TemperatureStreamState extends State<TemperatureStream> {
  final Stream<QuerySnapshot> _temperatureStream = db.collection("Babies").doc("IYyV2hqR7omIgeA4r7zQ").collection("Temperature").orderBy('date', descending: true).limit(1).snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _temperatureStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // An array of documents, but our query only returns an array of one document
        var lastTemperatureDoc = snapshot.data!.docs;

        DateTime date = lastTemperatureDoc[0]['date'].toDate();
        String dateStr = DateFormat('MM-dd hh:mm').format(date);
        String temperature = lastTemperatureDoc[0]['temperature'];
 

        // Returns the FilledCard with read values for temperature and date
        // updated in real time.
        return FilledCard(dateStr, "Temperature: $temperature", Icon(Icons.scale));
      },
    );
  }
}