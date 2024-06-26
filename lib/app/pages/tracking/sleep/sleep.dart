import 'package:babysteps/app/pages/calendar/Events/notifications.dart';
import 'package:babysteps/app/pages/tracking/sleep/add_previous_sleep.dart';
import 'package:babysteps/app/pages/tracking/sleep/sleep_database.dart';
import 'package:babysteps/app/pages/tracking/sleep/sleep_stream.dart';
import 'package:babysteps/app/widgets/loading_widget.dart';
import 'package:babysteps/app/widgets/stopwatch.dart';
import 'package:babysteps/app/widgets/history_widgets.dart';
import 'package:babysteps/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    //Get the ongoing data for the stopwatch
    QuerySnapshot ongoingSleepQuerySnapshot = await SleepDatabaseMethods()
        .getLatestOngoingSleepEntry(
            currentUser.value!.currentBaby.value!.collectionId);

    //If there's an ongoing timer, update the information the stopwatch will need.
    if (ongoingSleepQuerySnapshot.docs.isNotEmpty) {
      //Grab the id so we can update later
      id = ongoingSleepQuerySnapshot.docs[0].id;

      //Grab how much time has already elapsed
      timeSoFarInNap = DateTime.now()
          .difference(ongoingSleepQuerySnapshot.docs[0]['date'].toDate())
          .inMilliseconds;

      //set flag that stopwatch is going
      timerAlreadyStarted = true;
    }
    if (mounted) {
      setState(() {});
    }
    //Return this simply so the FutureBuilder can show the stopwatch
    return ongoingSleepQuerySnapshot;
  }

  //Upload data to the database with default value for length.
  //This method will be called when the timer is started
  uploadData() async {
    Map<String, dynamic> uploaddata = {
      'length': '--',
      'active': true,
      'date': DateTime.now(),
    };

    DocumentReference doc = await SleepDatabaseMethods().addSleepEntry(
        uploaddata, currentUser.value!.currentBaby.value!.collectionId);
    id = doc.id;
  }

  //Update data with the actual nap length
  //This method will be called when the timer is ended
  updateData(String napLength) async {
    if (id != null) {
      await SleepDatabaseMethods().updateSleepEntry(napLength, DateTime.now(),
          id!, currentUser.value!.currentBaby.value!.collectionId);

      //once data has been added, update the card accordingly
      napDone(napLength);
    }
    //Schedule notification for reminder in 2 hours 
    var today = DateTime.now();
    var twoHours = today.hour + 2;
     NotificationService().scheduleNotification(
            id: 0,
            title: "Nap Reminder",
            body: "Its been 2 hours since ${currentUser.value?.currentBaby.value?.name} has had a Nap"
                '$twoHours:${today.minute}',
            scheduledNotificationDateTime: DateTime(
                today.year,
                today.month,
                today.day,
                twoHours,
                today.minute));
  
  }

  void napDone(String napLength) {
    setState(() {
      timeSinceNap = "0:00";
      lastNap = napLength;
      timeSoFarInNap = 0;
      id = null;
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
      body: SingleChildScrollView(
          child: ValueListenableBuilder(
        valueListenable: currentUser,
        builder: (context, value, child) {
          if (value == null) {
            return const LoadingWidget();
          } else {
            return Center(
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text('Sleep',
                      style: TextStyle(
                          fontSize: 36,
                          color: Theme.of(context).colorScheme.onBackground)),
                ),

                // Filled Card reading data from SleepStream()
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: SizedBox(
                    child: SleepStream(),
                  ),
                ),
                //Using a future builder (should we be using a stream builder?)
                //This will ensure that we don't put up the stopwatch until we see if the stopwatch should still be going
                //if we get a return from the Future async call, then we'll display the stopwatch,
                //if there is any error, we'll display the message
                //else we'll just show a progress indicator saying that we're retrieving data
                FutureBuilder(
                  future: getData(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    List<Widget> children;
                    if (snapshot.hasData) {
                      children = <Widget>[
                        NewStopWatch("Nap", updateData, uploadData,
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

                // Add Previous Sleep
                const Padding(
                  padding: EdgeInsets.only(top: 30, left: 15, right: 15),
                  child: AddPreviousSleepCard(),
                ),

                // History Card - in widgets
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: HistoryDropdown("sleep"),
                ),
              ]),
            );
          }
        },
      )),
    );
  }
}
