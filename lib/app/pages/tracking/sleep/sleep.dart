import 'package:babysteps/app/pages/tracking/sleep/sleep_database.dart';
import 'package:babysteps/app/widgets/stopwatch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'dart:core';

class SleepPage extends StatefulWidget {
  const SleepPage({super.key});

  @override
  State<SleepPage> createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  //set defaults
  String timeSinceNap = "--";
  String lastNap = "--";
  String buttonText = "Nap";
  //these two will help the stopwatch look like it has the right time if the timer is ongoing
  int timeSoFarInNap = 0;
  bool timerAlreadyStarted = false;
  //this id will be used to update entry later
  String? id;

  //Get the data from the database
  Future getData() async {
    ///Get the most recent finished data for the card
    QuerySnapshot finishedSleepQuerySnapshot =
        await SleepDatabaseMethods().getLatestFinishedSleepEntry();
    //Get the ongoing data for the stopwatch
    QuerySnapshot ongoingSleepQuerySnapshot =
        await SleepDatabaseMethods().getLatestOngoingSleepEntry();
    //As long as we have data for the most recent finished sleep time,
    //we'll want to display the right information
    if (finishedSleepQuerySnapshot.docs.isNotEmpty) {
      try {
        lastNap = finishedSleepQuerySnapshot.docs[0]['length'];
        //Get the difference in time between now and when the last logged diaper was
        String diff = DateTime.now()
            .difference(DateTime.parse(
                finishedSleepQuerySnapshot.docs[0]['date'].toString()))
            .inMinutes
            .toString();
        timeSinceNap = diff == '1' ? '$diff min' : '$diff mins';
      } catch (error) {
        //If there's an error, print it to the output
        debugPrint(error.toString());
      }
    }
    //If there's an ongoing timer, update the information the stopwatch will need.
    if (ongoingSleepQuerySnapshot.docs.isNotEmpty) {
      //Grab the id so we can update later
      id = ongoingSleepQuerySnapshot.docs[0].id;
      //Grab how much time has already elapsed
      timeSoFarInNap = DateTime.now()
          .difference(DateTime.parse(
              ongoingSleepQuerySnapshot.docs[0]['date'].toString()))
          .inMilliseconds;
      //set flag that stopwatch is going
      timerAlreadyStarted = true;
    }
    if (mounted) {
      setState(() {});
    }
    //Return this simply so the FutureBuilder can show the stopwatch
    return finishedSleepQuerySnapshot;
  }

  //Upload data to the database with default value for length.
  //This method will be called when the timer is started
  uploadData() async {
    Map<String, dynamic> uploaddata = {
      'length': '--',
      'active': true,
      'date': DateTime.now().toIso8601String(),
    };

    await SleepDatabaseMethods().addSleepEntry(uploaddata);
  }

  //Update data with the actual nap length
  //This method will be called when the timer is ended
  updateData(String napLength) async {
    if (id != null) {
      await SleepDatabaseMethods()
          .updateSleepEntry(napLength, DateTime.now().toIso8601String(), id!);
      //once data has been added, update the card accordingly
      napDone(napLength);
    }
  }

  void napDone(String napLength) {
    setState(() {
      timeSinceNap = "0:00";
      lastNap = napLength;
      timeSoFarInNap = 0;
    });
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
      body:SingleChildScrollView(
      child: Center(
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
            child: SizedBox(height: 200, child: FilledCard("last nap: $timeSinceNap", "nap: $lastNap",
                Icon(Icons.person_search_sharp)),),
          ),
          //Using a future builder (should we be using a stream builder?)
          //This will ensure that we don't put up the stopwatch until we see if the stopwatch should still be going
          //if we get a return from the Future async call, then we'll display the stopwatch,
          //if there is any error, we'll display the message
          //else we'll just show a progress indicator saying that we're retrieving data
          FutureBuilder(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                children = <Widget>[
                  NewStopWatch(timeSinceNap, buttonText, updateData, uploadData,
                      timeSoFarInNap, timerAlreadyStarted),
                ];
              } else if (snapshot.hasError) {
                children = <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Color.fromRGBO(244, 67, 54, 1),
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                ];
              } else {
                children = const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Grabbing Data...'),
                  ),
                ];
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              );
            },
          ),
          //TODO: pass time since strings to the stopwatch widget!!
          // NewStopWatch(timeSinceNap, buttonText, updateData, uploadData,
          //     timeSoFarInNap, timerAlreadyStarted),
        ]),
      ),
      ),
    );
  }
}
