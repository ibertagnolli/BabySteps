import 'package:babysteps/app/pages/tracking/sleep/sleep_database.dart';
import 'package:babysteps/app/pages/tracking/weight/weight_database.dart';
import 'package:babysteps/app/pages/tracking/diaper/diaper_database.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

FirebaseFirestore db = FirebaseFirestore.instance;


// SLEEP  ** SLEEP IS THE ONLY ONE WITH A TABLE RIGHT NOW

class SleepHistoryStream extends StatefulWidget{
  @override
  _SleepHistoryStreamState createState() => _SleepHistoryStreamState();
}

class _SleepHistoryStreamState extends State<SleepHistoryStream> {
  final Stream<QuerySnapshot> _sleepHistoryStream = SleepDatabaseMethods().getStream();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _sleepHistoryStream,
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
        String day = date.day.toString();
        String time = date.hour.toString();
        //String dateStr = DateFormat('MM-dd hh:mm').format(date);
        String length = lastSleepDoc[0]['length'];

        // Source: https://api.flutter.dev/flutter/material/DataTable-class.html
        return DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Expanded(
                child: Text(
                  'Date',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Time',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Length',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ],
          //rows: const <DataRow>[
          rows: <DataRow> [
            DataRow(
              cells: <DataCell>[
                DataCell(Text('${day}')),
                DataCell(Text('${time}')),
                DataCell(Text('${length}')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('${day}')),
                DataCell(Text('${time}')),
                DataCell(Text('${length}')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('${day}')),
                DataCell(Text('${time}')),
                DataCell(Text('${length}')),
              ],
            ),
          ],
        );
      },
    );
  }
}


// WEIGHT

class WeightHistoryStream extends StatefulWidget{
  @override
  _WeightHistoryStreamState createState() => _WeightHistoryStreamState();
}

class _WeightHistoryStreamState extends State<WeightHistoryStream> {
  final Stream<QuerySnapshot> _weightHistoryStream = WeightDatabaseMethods().getStream();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _weightHistoryStream,
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

        // Returns the FilledCard with read values for date, pounds, and ounces
        // updated in real time.
        return FilledCard(dateStr, "weight: $pounds lbs $ounces oz", Icon(Icons.scale));
      },
    );
  }
}


// TEMP

class TemperatureHistoryStream extends StatefulWidget{
  @override
  _TemperatureHistoryStreamState createState() => _TemperatureHistoryStreamState();
}

class _TemperatureHistoryStreamState extends State<TemperatureHistoryStream> {
  final Stream<QuerySnapshot> _temperatureHistoryStream = db.collection("Babies").doc("IYyV2hqR7omIgeA4r7zQ").collection("Temperature").orderBy('date', descending: true).limit(1).snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _temperatureHistoryStream,
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


// DIAPER

class DiaperHistoryStream extends StatefulWidget {
  const DiaperHistoryStream({super.key});

  @override
  State<StatefulWidget> createState() => _DiaperHistoryStreamState();
}

class _DiaperHistoryStreamState extends State<DiaperHistoryStream> {
  final Stream<QuerySnapshot> _diaperHistoryStream =
      DiaperDatabaseMethods().getStream();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _diaperHistoryStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // An array of documents, but our query only returns an array of one document
        var lastDiaperDoc = snapshot.data!.docs;

        DateTime date = DateTime.parse(lastDiaperDoc[0]['date'].toString());
        String diff = DateTime.now().difference(date).inMinutes.toString();
        String timeSinceChange = diff == '1' ? '$diff min' : '$diff mins';
        String lastType = lastDiaperDoc[0]['type'];

        // Returns the FilledCard with read values for date, pounds, and ounces
        // updated in real time.
        return FilledCard("last change: $timeSinceChange", "type: $lastType",
            const Icon(Icons.person_search_sharp));
      },
    );
  }
}