import 'package:babysteps/app/widgets/stopwatch.dart';
import 'package:babysteps/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/history_widgets.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// DIAPER

class DiaperAllTimeStream extends StatefulWidget {
  const DiaperAllTimeStream({super.key});

  @override
  State<StatefulWidget> createState() => _DiaperAllTimeStreamState();
}

class _DiaperAllTimeStreamState extends State<DiaperAllTimeStream> {
  final Stream<QuerySnapshot> _diaperAllTimeStream = db
      .collection("Babies")
      .doc(currentUser.value!.currentBaby.value!.collectionId)
      .collection("Diaper")
      .orderBy('date', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _diaperAllTimeStream,
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
            entries, "Diapers Over Time", "Number of Diapers");
      },
    );
  }
}

// SLEEP

class SleepAllTimeStream extends StatefulWidget {
  const SleepAllTimeStream({super.key});

  @override
  State<StatefulWidget> createState() => _SleepAllTimeStreamState();
}

class _SleepAllTimeStreamState extends State<SleepAllTimeStream> {
  final Stream<QuerySnapshot> _sleepAllTimeStream = db
      .collection("Babies")
      .doc(currentUser.value!.currentBaby.value!.collectionId)
      .collection("Sleep")
      .where('active', isEqualTo: false)
      .orderBy('date', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _sleepAllTimeStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // An array of documents
        var allSleepDocs = snapshot.data!.docs;

        // Tracks entry date:number of entries
        Map<DateTime, double> entriesNumberPerDay = {};
        // Tracks date:total time slept that day
        Map<DateTime, double> entriesTotalTime = {};

        // Go through all docs
        for (var doc in allSleepDocs) {
          DateTime date = doc['date'].toDate();
          var month = date.month;
          var day = date.day;
          var year = date.year;

          String timeString = "${doc['length']}"; // format: hh:mm:ss
          var splitTimeString = timeString.split(':');
          // Time slept = hours + minutes
          double hoursSlept = double.parse(splitTimeString[0]) +
              double.parse(splitTimeString[1]) / 60;

          // Add one to the number of entries for that date, or set it to 1 if there were none
          entriesNumberPerDay.update(
              DateTime(year, month, day, 0), (v) => v + 1,
              ifAbsent: () => 1);
          // Add the time to the current amount for that date, or set it to that time if there was nothing yet
          entriesTotalTime.update(
              DateTime(year, month, day, 0), (v) => v + hoursSlept,
              ifAbsent: () => hoursSlept);
        }

        // Make a graph with the retrieved data
        return StackedTimeSeriesWidget(entriesNumberPerDay, entriesTotalTime,
            "Sleep Over Time", "Number of Sleeps", "Total Time Slept (hrs)");
      },
    );
  }
}

// WEIGHT

class WeightAllTimeStream extends StatefulWidget {
  const WeightAllTimeStream({super.key});

  @override
  State<StatefulWidget> createState() => _WeightAllTimeStreamState();
}

class _WeightAllTimeStreamState extends State<WeightAllTimeStream> {
  final Stream<QuerySnapshot> _weightAllTimeStream = db
      .collection("Babies")
      .doc(currentUser.value!.currentBaby.value!.collectionId)
      .collection("Weight")
      .orderBy('date',
          descending: false) // False because we'll go through them in
      // order, and the last one for each day will be the one that's kept - we want
      // that to be the most recent one
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _weightAllTimeStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // An array of documents
        var allWeightDocs = snapshot.data!.docs;

        // Tracks entry date:most recent (last) weight for that date
        Map<DateTime, double> entries = {};

        // Go through all docs
        for (var doc in allWeightDocs) {
          DateTime date = doc['date'].toDate();
          var month = date.month;
          var day = date.day;
          var year = date.year;
          // Get weight
          double pounds = double.parse(doc['pounds']);
          double ounces = double.parse(doc['ounces']);
          double weight = pounds + ounces / 16; // in terms of pounds

          // TODO: This will only use the last entry for the day, do we want an average?
          entries.update(DateTime(year, month, day, 0), (v) => weight,
              ifAbsent: () => weight);
        }

        // Make a graph with the retrieved data
        return TimeSeriesWidget(entries, "Weight Over Time", "Pounds");
      },
    );
  }
}

// TEMPERATURE

class TemperatureAllTimeStream extends StatefulWidget {
  const TemperatureAllTimeStream({super.key});

  @override
  State<StatefulWidget> createState() => _TemperatureAllTimeStreamState();
}

class _TemperatureAllTimeStreamState extends State<TemperatureAllTimeStream> {
  final Stream<QuerySnapshot> _temperatureAllTimeStream = db
      .collection("Babies")
      .doc(currentUser.value!.currentBaby.value!.collectionId)
      .collection("Temperature")
      .orderBy('date',
          descending: false) // False because we'll go through them in
      // order, and the last one for each day will be the one that's kept - we want
      // that to be the most recent one
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _temperatureAllTimeStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // An array of documents
        var allTempDocs = snapshot.data!.docs;

        // Track entry date:most recent (last) temp for that day
        Map<DateTime, double> entries = {};

        // Go through all docs
        for (var doc in allTempDocs) {
          DateTime date = doc['date'].toDate();
          var month = date.month;
          var day = date.day;
          var year = date.year;
          double temp = double.parse(doc['temperature']);

          // TODO: this will only use the last entry for each day, would an average be better?
          entries.update(DateTime(year, month, day, 0), (v) => temp,
              ifAbsent: () => temp);
        }

        // Make a graph with the retrieved data
        return TimeSeriesWidget(entries, "Temperature Over Time", "Degrees");
      },
    );
  }
}

// BREASTFEEDING

class BreastfeedingAllTimeStream extends StatefulWidget {
  const BreastfeedingAllTimeStream({super.key});

  @override
  State<StatefulWidget> createState() => _BreastfeedingAllTimeStreamState();
}

class _BreastfeedingAllTimeStreamState
    extends State<BreastfeedingAllTimeStream> {
  final Stream<QuerySnapshot> _breastfeedingAllTimeStream = db
      .collection("Babies")
      .doc(currentUser.value!.currentBaby.value!.collectionId)
      .collection("Feeding")
      .where('type', isEqualTo: 'BreastFeeding')
      .where('active', isEqualTo: false)
      .orderBy('date', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _breastfeedingAllTimeStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // An array of documents
        var allBreastfeedingDocs = snapshot.data!.docs;

        // Tracks entry date:number of entries
        Map<DateTime, double> entriesNumberPerDate = {};
        // Tracks date:total time spend feeding that day
        Map<DateTime, double> entriesTotalTime = {};

        // Go through all docs
        for (var doc in allBreastfeedingDocs) {
          DateTime date = doc['date'].toDate();
          var month = date.month;
          var day = date.day;
          var year = date.year;

          String timeString =
              transformMilliSeconds(doc['length']); // format: hh:mm:ss
          var splitTimeString = timeString.split(':');
          // Time fed = hours + minutes
          double hoursBreastfed = double.parse(splitTimeString[0]) +
              double.parse(splitTimeString[1]) / 60;
          // TODO: hrs or minutes better for breastfeeding?

          // Add one to the number of entries for that date, or set it to 1 if there were none
          entriesNumberPerDate.update(
              DateTime(year, month, day, 0), (v) => v + 1,
              ifAbsent: () => 1);
          // Add the time to the current amount for that date, or set it to that time if there was nothing yet
          entriesTotalTime.update(
              DateTime(year, month, day, 0), (v) => v + hoursBreastfed,
              ifAbsent: () => hoursBreastfed);
        }

        // Make a graph with the retrieved data
        return StackedTimeSeriesWidget(
            entriesNumberPerDate,
            entriesTotalTime,
            "Breastfeeding Over Time",
            "Number of Feeds",
            "Total Time Fed (hrs)");
      },
    );
  }
}

// BOTTLE FEEDING

class BottleFeedingAllTimeStream extends StatefulWidget {
  const BottleFeedingAllTimeStream({super.key});

  @override
  State<StatefulWidget> createState() => _BottleFeedingAllTimeStreamState();
}

class _BottleFeedingAllTimeStreamState
    extends State<BottleFeedingAllTimeStream> {
  final Stream<QuerySnapshot> _bottleFeedingAllTimeStream = db
      .collection("Babies")
      .doc(currentUser.value!.currentBaby.value!.collectionId)
      .collection("Feeding")
      .where('type', isEqualTo: 'Bottle')
      .where('active', isEqualTo: false)
      .orderBy('date', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _bottleFeedingAllTimeStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // An array of documents
        var allBottleDocs = snapshot.data!.docs;

        // Track entry date:number of entries
        Map<DateTime, double> entriesNumberPerDate = {};
        // Track date:total amount fed that day
        Map<DateTime, double> entriesTotalAmount = {};

        // Go through all docs
        for (var doc in allBottleDocs) {
          DateTime date = doc['date'].toDate();
          var month = date.month;
          var day = date.day;
          var year = date.year;

          double bottleAmount = double.parse(doc['ounces']);

          // Add one to the number of entries for that date, or set it to 1 if there were none
          entriesNumberPerDate.update(
              DateTime(year, month, day, 0), (v) => v + 1,
              ifAbsent: () => 1);
          // Add the amount (in oz) to the current amount for that date, or set it to that amount if there was nothing yet
          entriesTotalAmount.update(
              DateTime(year, month, day, 0), (v) => v + bottleAmount,
              ifAbsent: () => bottleAmount);
        }

        // Make a graph with the retrieved data
        return StackedTimeSeriesWidget(
            entriesNumberPerDate,
            entriesTotalAmount,
            "Bottle Feeds Over Time",
            "Number of Feeds",
            "Total Amount Fed (oz)");
      },
    );
  }
}
