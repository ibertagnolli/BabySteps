import 'package:babysteps/app/widgets/stopwatch.dart';
import 'package:babysteps/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:babysteps/app/widgets/history_widgets.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// BREASTFEEDING

class BreastfeedingHistoryStream extends StatefulWidget {
  const BreastfeedingHistoryStream({super.key});

  @override
  _BreastfeedingHistoryStreamState createState() =>
      _BreastfeedingHistoryStreamState();
}

class _BreastfeedingHistoryStreamState
    extends State<BreastfeedingHistoryStream> {
  final Stream<QuerySnapshot> _breastfeedingHistoryStream = db
      .collection("Babies")
      .doc(currentUser.value!.currentBaby.value!.collectionId)
      .collection("Feeding")
      .where('type', isEqualTo: 'BreastFeeding')
      .where('active', isEqualTo: false)
      .orderBy('date', descending: true)
      .limit(
          5) // TODO: How many do we want? Specific number? Any from "this week"?
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _breastfeedingHistoryStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // An array of documents
        var lastBreastfeedingDocs = snapshot.data!.docs;

        // List of RowData objects to hold data for the table
        List<RowData6Cols> rows = [];
        //List<RowData4Cols> rows = [];

        // For however many most recent docs we have, get relevant info and build a row for it
        for (var doc in lastBreastfeedingDocs) {
          DateTime date = doc['date'].toDate();
          String dateStr = DateFormat('MM-dd hh:mm a').format(date);
          var splitDate = dateStr.split(' '); // needed to get am/pm
          String day = splitDate[0];
          String time = splitDate[1] + splitDate[2];
          String totalLength = transformMilliSeconds(doc['length']);
          String lastSide = doc['side']['latest'];
          String leftLength =
              transformMilliSeconds(doc['side']['left']['duration']);
          String rightLength =
              transformMilliSeconds(doc['side']['right']['duration']);

          rows.add(RowData6Cols(
              day, time, leftLength, rightLength, totalLength, lastSide));
          //rows.add(RowData4Cols(day, time, leftLength, rightLength));
        }

        // Make a table with the retrieved data
        return HistoryTable6Cols(
            rows, "Left Length", "Right Length", "Total Time", "Ended On");
        //return HistoryTable4Cols(rows, "Left Length", "Right Length");
      },
    );
  }
}

// BOTTLE FEEDING

class BottleHistoryStream extends StatefulWidget {
  const BottleHistoryStream({super.key});

  @override
  _BottleHistoryStreamState createState() => _BottleHistoryStreamState();
}

class _BottleHistoryStreamState extends State<BottleHistoryStream> {
  final Stream<QuerySnapshot> _bottleHistoryStream = db
      .collection("Babies")
      .doc(currentUser.value!.currentBaby.value!.collectionId)
      .collection("Feeding")
      .where('type', isEqualTo: 'Bottle')
      .where('active', isEqualTo: false)
      .orderBy('date', descending: true)
      .limit(
          5) // TODO: How many do we want? Specific number? Any from "this week"?
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _bottleHistoryStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // An array of documents, but our query only returns an array of one document ** NOT THIS TIME, THIS IS ACTUALLY AN ARRAY NOW
        var lastBottleDocs = snapshot.data!.docs;

        List<RowData4Cols> rows = [];

        // For however many most recent docs we have, build a row for it
        for (var doc in lastBottleDocs) {
          DateTime date = doc['date'].toDate();
          String dateStr = DateFormat('MM-dd hh:mm a').format(date);
          var splitDate = dateStr.split(' ');
          String day = splitDate[0];
          String time = splitDate[1] + splitDate[2];
          String bottleType = doc['bottleType'];
          String amount = doc['ounces'] + " oz";

          rows.add(RowData4Cols(day, time, amount, bottleType, doc.id));
        }

        // Make a table with the retrieved data
        return HistoryTable4Cols("Bottle", rows, "Amount", "Bottle Type");
      },
    );
  }
}

// SLEEP

class SleepHistoryStream extends StatefulWidget {
  const SleepHistoryStream({super.key});

  @override
  _SleepHistoryStreamState createState() => _SleepHistoryStreamState();
}

class _SleepHistoryStreamState extends State<SleepHistoryStream> {
  final Stream<QuerySnapshot> _sleepHistoryStream = db
      .collection("Babies")
      .doc(currentUser.value!.currentBaby.value!.collectionId)
      .collection("Sleep")
      .orderBy('date', descending: true)
      .limit(
          5) // TODO: How many do we want? Specific number? Any from "this week"?
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

        // List of RowData objects holding data for the table
        List<RowData3Cols> rows = [];

        // For however many most recent docs we have, build a row for it
        for (var doc in lastSleepDocs) {
          DateTime date = doc['date'].toDate();
          String dateStr = DateFormat('MM-dd hh:mm a').format(date);
          var splitDate = dateStr.split(' ');
          String day = splitDate[0];
          String time = splitDate[1] + splitDate[2];
          String length = doc['length'];

          rows.add(RowData3Cols(day, time, length));
        }

        // Make a table with the retrieved data
        return HistoryTable3Cols(rows, "Length");
      },
    );
  }
}

// WEIGHT

class WeightHistoryStream extends StatefulWidget {
  const WeightHistoryStream({super.key});

  @override
  _WeightHistoryStreamState createState() => _WeightHistoryStreamState();
}

class _WeightHistoryStreamState extends State<WeightHistoryStream> {
  final Stream<QuerySnapshot> _weightHistoryStream = db
      .collection("Babies")
      .doc(currentUser.value!.currentBaby.value!.collectionId)
      .collection("Weight")
      .orderBy('date', descending: true)
      .limit(
          5) // TODO: How many do we want? Specific number? Any from "this week"?
      .snapshots();

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

        // An array of documents, but our query only returns an array of one document ** NOT THIS TIME, THIS IS ACTUALLY AN ARRAY NOW
        var lastWeightDocs = snapshot.data!.docs;

        // List of RowData objects holding data for the table
        List<RowData3Cols> rows = [];

        // For however many most recent docs we have, build a row for it
        for (var doc in lastWeightDocs) {
          DateTime date = doc['date'].toDate();
          String dateStr = DateFormat('MM-dd hh:mm a').format(date);
          var splitDate = dateStr.split(' ');
          String day = splitDate[0];
          String time = splitDate[1] + splitDate[2];
          String pounds = doc['pounds'];
          String ounces = doc['ounces'];
          String weight = '$pounds lbs $ounces oz';

          rows.add(RowData3Cols(day, time, weight));
        }

        // Make a table with the retrieved data
        return HistoryTable3Cols(rows, "Weight");
      },
    );
  }
}

// TEMPERATURE

class TemperatureHistoryStream extends StatefulWidget {
  const TemperatureHistoryStream({super.key});

  @override
  _TemperatureHistoryStreamState createState() =>
      _TemperatureHistoryStreamState();
}

class _TemperatureHistoryStreamState extends State<TemperatureHistoryStream> {
  final Stream<QuerySnapshot> _temperatureHistoryStream = db
      .collection("Babies")
      .doc(currentUser.value!.currentBaby.value!.collectionId)
      .collection("Temperature")
      .orderBy('date', descending: true)
      .limit(
          5) // TODO: How many do we want? Specific number? Any from "this week"?
      .snapshots();

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

        // An array of documents, but our query only returns an array of one document ** NOT THIS TIME, THIS IS ACTUALLY AN ARRAY NOW
        var lastTemperatureDocs = snapshot.data!.docs;

        // List of RowData objects holding data for the table
        List<RowData3Cols> rows = [];

        // For however many most recent docs we have, build a row for it
        for (var doc in lastTemperatureDocs) {
          DateTime date = doc['date'].toDate();
          String dateStr = DateFormat('MM-dd hh:mm a').format(date);
          var splitDate = dateStr.split(' ');
          String day = splitDate[0];
          String time = splitDate[1] + splitDate[2];
          String temperature = doc['temperature'];

          rows.add(RowData3Cols(day, time, temperature));
        }

        // Make a table with the retrieved data
        return HistoryTable3Cols(rows, "Temperature");
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
  final Stream<QuerySnapshot> _diaperHistoryStream = db
      .collection("Babies")
      .doc(currentUser.value!.currentBaby.value!.collectionId)
      .collection("Diaper")
      .orderBy('date', descending: true)
      .limit(
          5) // TODO: How many do we want? Specific number? Any from "this week"?
      .snapshots();

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

        // An array of documents, but our query only returns an array of one document ** NOT THIS TIME, THIS IS ACTUALLY AN ARRAY NOW
        var lastDiaperDocs = snapshot.data!.docs;

        // List of RowData objects holding data for the table
        List<RowData4Cols> rows = [];

        // For however many most recent docs we have, build a row for it
        for (var doc in lastDiaperDocs) {
          DateTime date = doc['date'].toDate();
          String dateStr = DateFormat('MM-dd hh:mm a').format(date);
          var splitDate = dateStr.split(' ');
          String day = splitDate[0];
          String time = splitDate[1] + splitDate[2];
          String diaperType = doc['type'];
          bool diaperRashBool = doc['rash'];
          String diaperRash = diaperRashBool ? "Yes" : "No";

          rows.add(RowData4Cols(day, time, diaperType, diaperRash, doc.id));
        }

        // Make a table with the retrieved data
        return HistoryTable4Cols("Diaper", rows, "Diaper Type", "Diaper Rash?");
      },
    );
  }
}
