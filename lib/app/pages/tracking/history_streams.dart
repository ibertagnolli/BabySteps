import 'package:babysteps/app/widgets/stopwatch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:babysteps/main.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
String? babyDoc = currentUser.babies[0].collectionId; //TODO: get current baby

// Breastfeeding - first shows the accurate most recent entries, then if you make a new entry it overwrites
// the most recent entry on that same side
// Bottle feeding - all good besides "amount" is currently hardcoded because it's not part of the database
// Sleep - first shows the accurate most recent entries, then if you make a new entry it'll overwrite the
// most recent one -- it's actually getting overwritten in the database though????
// Diaper - all good
// Weight - only autofills date for the first one, then the datepicker doesn't include a time so it's all 12:00
// Temp - same as weight

// Represents the data shown in the history table when we only need 3 columns
class RowData3Cols<T1, T2, T3> {
  T1 day;
  T2 time;
  T3 data;

  RowData3Cols(this.day, this.time, this.data);
}

// Represents the data shown in the history table when we need 4 columns
class RowData4Cols<T1, T2, T3, T4> {
  T1 day;
  T2 time;
  T3 data1;
  T4 data2;

  RowData4Cols(this.day, this.time, this.data1, this.data2);
}

// BREASTFEEDING

class BreastfeedingHistoryStream extends StatefulWidget {
  @override
  _BreastfeedingHistoryStreamState createState() =>
      _BreastfeedingHistoryStreamState();
}

class _BreastfeedingHistoryStreamState
    extends State<BreastfeedingHistoryStream> {
  final Stream<QuerySnapshot> _breastfeedingHistoryStream = db
      .collection("Babies")
      .doc(babyDoc ?? "IYyV2hqR7omIgeA4r7zQ")
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
        List<RowData4Cols> rows = [];

        // For however many most recent docs we have, get relevant info and build a row for it
        lastBreastfeedingDocs.forEach((doc) {
          DateTime date1 = doc['date'].toDate();
          String dateStr1 = DateFormat('MM-dd hh:mm').format(date1);
          var splitDate1 = dateStr1.split(' ');
          String day = splitDate1[0];
          String time = splitDate1[1];
          String length = transformMilliSeconds(doc['length']);
          String side = doc['side']['latest'];

          rows.add(RowData4Cols(day, time, length, side));
        });

        // Make a table with the retrieved data
        return HistoryTable4Cols(rows, "Length", "Side");
      },
    );
  }
}

// BOTTLE FEEDING

class BottleHistoryStream extends StatefulWidget {
  @override
  _BottleHistoryStreamState createState() => _BottleHistoryStreamState();
}

class _BottleHistoryStreamState extends State<BottleHistoryStream> {
  final Stream<QuerySnapshot> _bottleHistoryStream = db
      .collection("Babies")
      .doc(babyDoc ?? "IYyV2hqR7omIgeA4r7zQ")
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
        lastBottleDocs.forEach((doc) {
          DateTime date1 = doc['date'].toDate();
          String dateStr1 = DateFormat('MM-dd hh:mm').format(date1);
          var splitDate1 = dateStr1.split(' ');
          String day = splitDate1[0];
          String time = splitDate1[1];
          String bottleType = doc['bottleType'];
          String amount = "4 oz";

          rows.add(RowData4Cols(day, time, amount, bottleType));
        });

        // Make a table with the retrieved data
        return HistoryTable4Cols(rows, "Amount", "Bottle Type");
      },
    );
  }
}

// SLEEP

class SleepHistoryStream extends StatefulWidget {
  @override
  _SleepHistoryStreamState createState() => _SleepHistoryStreamState();
}

class _SleepHistoryStreamState extends State<SleepHistoryStream> {
  final Stream<QuerySnapshot> _sleepHistoryStream = db
      .collection("Babies")
      .doc(babyDoc ?? "IYyV2hqR7omIgeA4r7zQ")
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
        lastSleepDocs.forEach((doc) {
          DateTime date1 = doc['date'].toDate();
          String dateStr1 = DateFormat('MM-dd hh:mm').format(date1);
          var splitDate1 = dateStr1.split(' ');
          String day = splitDate1[0];
          String time = splitDate1[1];
          String length = doc['length'];

          rows.add(RowData3Cols(day, time, length));
        });

        // Make a table with the retrieved data
        return HistoryTable3Cols(rows, "Length");
      },
    );
  }
}

// WEIGHT

class WeightHistoryStream extends StatefulWidget {
  @override
  _WeightHistoryStreamState createState() => _WeightHistoryStreamState();
}

class _WeightHistoryStreamState extends State<WeightHistoryStream> {
  final Stream<QuerySnapshot> _weightHistoryStream = db
      .collection("Babies")
      .doc(babyDoc ?? "IYyV2hqR7omIgeA4r7zQ")
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
        lastWeightDocs.forEach((doc) {
          DateTime date1 = doc['date'].toDate();
          String dateStr1 = DateFormat('MM-dd hh:mm').format(date1);
          var splitDate1 = dateStr1.split(' ');
          String day = splitDate1[0];
          String time = splitDate1[1];
          String pounds = doc['pounds'];
          String ounces = doc['ounces'];
          String weight = '$pounds lbs $ounces oz';

          rows.add(RowData3Cols(day, time, weight));
        });

        // Make a table with the retrieved data
        return HistoryTable3Cols(rows, "Weight");
      },
    );
  }
}

// TEMPERATURE

class TemperatureHistoryStream extends StatefulWidget {
  @override
  _TemperatureHistoryStreamState createState() =>
      _TemperatureHistoryStreamState();
}

class _TemperatureHistoryStreamState extends State<TemperatureHistoryStream> {
  final Stream<QuerySnapshot> _temperatureHistoryStream = db
      .collection("Babies")
      .doc(babyDoc ?? "IYyV2hqR7omIgeA4r7zQ")
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
        lastTemperatureDocs.forEach((doc) {
          DateTime date1 = doc['date'].toDate();
          String dateStr1 = DateFormat('MM-dd hh:mm').format(date1);
          var splitDate1 = dateStr1.split(' ');
          String day = splitDate1[0];
          String time = splitDate1[1];
          String temperature = doc['temperature'];

          rows.add(RowData3Cols(day, time, temperature));
        });

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
      .doc(babyDoc ?? "IYyV2hqR7omIgeA4r7zQ")
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
        lastDiaperDocs.forEach((doc) {
          DateTime date1 = doc['date'].toDate();
          String dateStr1 = DateFormat('MM-dd hh:mm').format(date1);
          var splitDate1 = dateStr1.split(' ');
          String day = splitDate1[0];
          String time = splitDate1[1];
          String diaperType = doc['type'];
          bool diaperRashBool = doc['rash'];
          String diaperRash = diaperRashBool ? "Yes" : "No";

          rows.add(RowData4Cols(day, time, diaperType, diaperRash));
        });

        // Make a table with the retrieved data
        return HistoryTable4Cols(rows, "Diaper Type", "Diaper Rash?");
      },
    );
  }
}

// Table with 3 columns, column titles, and rows of data filled in
class HistoryTable3Cols extends StatelessWidget {
  HistoryTable3Cols(this.rows, this.colName, {super.key});

  var rows;
  String colName;

  @override
  Widget build(BuildContext context) {
    // Source: https://api.flutter.dev/flutter/material/DataTable-class.html
    return DataTable(
      columns: <DataColumn>[
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
              '$colName',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
      // Table rows - dynamic - For each row we collected data for, create a DataCell for it
      // TODO: Some sort of "no history yet" message if there are no entries
      rows: <DataRow>[
        for (var row in rows)
          DataRow(
            cells: <DataCell>[
              DataCell(Text(row.day)),
              DataCell(Text(row.time)),
              DataCell(Text(row.data)),
            ],
          ),
      ],
    );
  }
}

// Table with 4 columns, column titles, and data filled in
class HistoryTable4Cols extends StatelessWidget {
  HistoryTable4Cols(this.rows, this.col1Name, this.col2Name, {super.key});

  var rows;
  String col1Name;
  String col2Name;

  @override
  Widget build(BuildContext context) {
    // Source: https://api.flutter.dev/flutter/material/DataTable-class.html
    return DataTable(
      columns: <DataColumn>[
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
              '$col1Name',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              '$col2Name',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
      // Table rows - dynamic - For each row we collected data for, create a DataCell for it
      // TODO: Some sort of "no history yet" message if there are no entries
      rows: <DataRow>[
        for (var row in rows)
          DataRow(
            cells: <DataCell>[
              DataCell(Text(row.day)),
              DataCell(Text(row.time)),
              DataCell(Text(row.data1)),
              DataCell(Text(row.data2))
            ],
          ),
      ],
    );
  }
}
