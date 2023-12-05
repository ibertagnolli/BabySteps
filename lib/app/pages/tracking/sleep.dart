import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:babysteps/app/widgets/stopwatch.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'dart:core';

class SleepPage extends StatefulWidget {
  const SleepPage({super.key});

  @override
  State<SleepPage> createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  CollectionReference nap = FirebaseFirestore.instance.collection('nap');
  String timeSinceNap = "4:38";
  String lastNap = "0:55";
  String buttonText = "Nap";

  void napDone(String napLength) {
    setState(() {
      timeSinceNap = "0:00";
      lastNap = napLength;
    });

  }

Future<void> saveNewNap() {
    DateTime currentDate = DateTime.now();

    // Write weight data to database
    return nap
        .add({
          'timeSince': timeSinceNap,
          'last': lastNap,
          // TODO add userID
        })
        .then((value) => napDone(lastNap))
        .catchError((error) => debugPrint("nap couldn't be added: $error"));

    // TODO show something when the date is saved (check mark?)
    // TODO prevent user from inserting the data entry multiple times -> disable the Save button?
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Tracking'),
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      body: Center(
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(32),
            child: Text('Sleep',
                style: TextStyle(
                    fontSize: 36,
                    color: Theme.of(context).colorScheme.onBackground)),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: FilledCard("last nap: $timeSinceNap", "nap: $lastNap",
                Icon(Icons.person_search_sharp)),
          ),

          //TODO: pass time since strings to the stopwatch widget!!
          NewStopWatch(timeSinceNap, buttonText, napDone),
        ]),
      ),
    );
  }
}
