import 'package:babysteps/app/pages/tracking/sleep/sleep_database.dart';
import 'package:babysteps/app/pages/tracking/weight/weight_database.dart';
import 'package:babysteps/app/pages/tracking/diaper/diaper_database.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:babysteps/main.dart';

FirebaseFirestore db = FirebaseFirestore.instance;


// SLEEP  ** SLEEP IS THE ONLY ONE IMPLEMENTED RIGHT NOW

// BUG: Shows the accurate most recent 3 entries, then if I start a new nap it'll update the most 
// recent one, but the 2 under it stay the same (it should always show the most recent 3, so every 
// new nap should just shift them all down 1)

// Class to represent data show in the sleep history table
class SleepRowData<T1, T2, T3> {
  T1 day;
  T2 time;
  T3 length;

  SleepRowData(this.day, this.time, this.length);
}

class SleepHistoryStream extends StatefulWidget{
  @override
  _SleepHistoryStreamState createState() => _SleepHistoryStreamState();
}

class _SleepHistoryStreamState extends State<SleepHistoryStream> {
  //final Stream<QuerySnapshot> _sleepHistoryStream = SleepDatabaseMethods().getStream();

  final Stream<QuerySnapshot> _sleepHistoryStream = db
        .collection("Babies")
        .doc(prefs?.getString('babyDoc') ?? "IYyV2hqR7omIgeA4r7zQ")
        .collection("Sleep")
        .orderBy('date', descending: true)
        .limit(3) // TODO: How many do we want? Specific number? Any from "this week"?
        .snapshots();

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

        // An array of documents, but our query only returns an array of one document ** NOT THIS TIME, THIS IS ACTUALLY AN ARRAY NOW
        var lastSleepDocs = snapshot.data!.docs;

        List<SleepRowData> rows = [];

        // For however many most recent docs we have, build a row for it
        lastSleepDocs.forEach((doc) {
          DateTime date1 = doc['date'].toDate();
          String dateStr1 = DateFormat('MM-dd hh:mm').format(date1);
          var splitDate1 = dateStr1.split(' ');
          String day = splitDate1[0];
          String time = splitDate1[1];
          String length = doc['length'];

          rows.add(SleepRowData(day, time, length));
        });

        // Source: https://api.flutter.dev/flutter/material/DataTable-class.html
        return DataTable(
          columns: const <DataColumn>[
            // Table column titles
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
          // Table rows - dynamic - For each row we collected data for, create a DataCell for it
          // TODO: Some sort of "no history yet" message if there are no entries 
          rows: <DataRow> [
            for (var row in rows)
              DataRow(
                cells: <DataCell>[
                  DataCell(Text(row.day)),
                  DataCell(Text(row.time)),
                  DataCell(Text(row.length)),
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