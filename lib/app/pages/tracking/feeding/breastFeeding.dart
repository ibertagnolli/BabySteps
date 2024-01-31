import 'package:babysteps/app/pages/tracking/feeding/feeding_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/stopwatch.dart';
import 'package:babysteps/app/pages/tracking/feeding/breastfeeding_stream.dart';
import 'package:babysteps/app/pages/tracking/history_streams.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'dart:core';

class BreastFeedingPage extends StatefulWidget {
  const BreastFeedingPage({super.key});

  @override
  State<BreastFeedingPage> createState() => _BreastFeedingPageState();
}

class _BreastFeedingPageState extends State<BreastFeedingPage> {
  String timeSince = "--";
  String lastSide = "Left";
  String buttonTextL = "left";
  String buttonTextR = "right";
  bool leftSideGoing = false;
  bool rightSideGoing = false;
  //Ids for the update method so we know what documents we're updating
  String? leftId;
  String? rightId;
  //Inital time on the right and left
  int timeSoFarOnLeft = 0;
  int timeSoFarOnRight = 0;

  //Get the data from the database
  Future getData() async {
    //Get the most recent finished data
    QuerySnapshot finishedBreastFeedingQuerySnapshot =
        await FeedingDatabaseMethods().getLatestFinishedBreastFeedingEntry();
    //Get the ongoing left side data
    QuerySnapshot ongoingLeftBreastFeedingQuerySnapshot =
        await FeedingDatabaseMethods().getLatestOngoingLeftBreastFeedingEntry();
    //Get the ongoing right side data
    QuerySnapshot ongoingRightBreastFeedingQuerySnapshot =
        await FeedingDatabaseMethods()
            .getLatestOngoingRightBreastFeedingEntry();
    //make sure we don't try to access an index that doesn't exist
    if (finishedBreastFeedingQuerySnapshot.docs.isNotEmpty) {
      try {
        //update the last side from the finished breast feeding query
        lastSide = finishedBreastFeedingQuerySnapshot.docs[0]['side'];
        //get the elapsed time between now and the time that the last information was logged
        String diff = DateTime.now()
            .difference(DateTime.parse(
                finishedBreastFeedingQuerySnapshot.docs[0]['date'].toString()))
            .inMinutes
            .toString();
        timeSince = diff == '1' ? '$diff min' : '$diff mins';
      } catch (error) {
        //If there's an error, print it to the output
        debugPrint(error.toString());
      }
    }
    //make sure we don't try to access an index that doesn't exist
    if (ongoingLeftBreastFeedingQuerySnapshot.docs.isNotEmpty) {
      //get the document id so we can update it later
      leftId = ongoingLeftBreastFeedingQuerySnapshot.docs[0].id;
      //calculate the time in miliseconds from the last time the left side was started
      timeSoFarOnLeft = DateTime.now()
          .difference(DateTime.parse(
              ongoingLeftBreastFeedingQuerySnapshot.docs[0]['date'].toString()))
          .inMilliseconds;
      //since ongoingLeft isn't empty, the timer is running so set flag accordingly
      leftSideGoing = true;
    }
    //make sure we don't try to access an index that doesn't exist
    if (ongoingRightBreastFeedingQuerySnapshot.docs.isNotEmpty) {
      //get the document id so we can update it later
      rightId = ongoingRightBreastFeedingQuerySnapshot.docs[0].id;
      //calculate the time in miliseconds from the last time the right side was started
      timeSoFarOnRight = DateTime.now()
          .difference(DateTime.parse(ongoingRightBreastFeedingQuerySnapshot
              .docs[0]['date']
              .toString()))
          .inMilliseconds;
      //since ongoingRight isn't empty, the timer is running so set flag accordingly
      rightSideGoing = true;
    }
    if (mounted) {
      setState(() {});
    }
    //Have a return so that the FutureBuilder in the build knows we've finished
    return finishedBreastFeedingQuerySnapshot;
  }

  //Upload the original data, this will be called once the stopwatch is started so we don't know the length yet
  uploadLeftData() async {
    Map<String, dynamic> uploaddata = {
      'type': 'BreastFeeding',
      'side': 'Left',
      'length': '--',
      'bottleType': '--',
      'active': true,
      'date': DateTime.now(),
    };

    await FeedingDatabaseMethods().addFeedingEntry(uploaddata);
  }

  //Update the left side data, this will happen once the stopwatch is stopped and we'll pass through the new
  //feeding length. The updateFeedingEntry will also set active to false for this document
  updateLeftData(String feedingLength) async {
    if (leftId != null) {
      await FeedingDatabaseMethods().updateFeedingEntry(feedingLength, leftId!);
      //once data has been added, update the card accordingly
      leftFeedingDone(feedingLength);
    }
  }

  //Upload the original data for the right side, this will be called once the stopwatch is started so we don't know the length yet
  //TODO: use one method passing through "left" and "right" for the side to condense code
  uploadRightData() async {
    Map<String, dynamic> uploaddata = {
      'type': 'BreastFeeding',
      'side': 'Right',
      'length': '--',
      'bottleType': '--',
      'active': true,
      'date': DateTime.now(),
    };

    await FeedingDatabaseMethods().addFeedingEntry(uploaddata);
  }

  //Update the right side data, this will happen once the stopwatch is stopped and we'll pass through the new
  //feeding length. The updateFeedingEntry will also set active to false for this document
  updateRightData(String feedingLength) async {
    if (rightId != null) {
      await FeedingDatabaseMethods()
          .updateFeedingEntry(feedingLength, rightId!);
      //once data has been added, update the card accordingly
      rightFeedingDone(feedingLength);
    }
  }

  void leftSideClicked() {
    setState(() {
      leftSideGoing = !leftSideGoing;
    });
  }

  void rightSideClicked() {
    setState(() {
      rightSideGoing = !rightSideGoing;
    });
  }

  void doneClicked() {
    setState(() {
      leftSideGoing = false;
      rightSideGoing = false;
      // Reset time since last feed
    });
  }

  void leftFeedingDone(String feedingLength) {
    setState(() {
      timeSince = "0:00";
      lastSide = "Left";
    });
  }

  void rightFeedingDone(String feedingLength) {
    setState(() {
      timeSince = "0:00";
      lastSide = "Right";
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
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(32),
                child: Text('Breast Feeding',
                    style: TextStyle(
                        fontSize: 36,
                        color: Theme.of(context).colorScheme.onBackground)),
              ),

              // Top card with info
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: BreastFeedingStream(),
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
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 200,
                              width: 195,
                              child: NewStopWatch(
                                  timeSince,
                                  buttonTextL,
                                  updateLeftData,
                                  uploadLeftData,
                                  timeSoFarOnLeft,
                                  leftSideGoing),
                            ),
                            SizedBox(
                              height: 200,
                              width: 195,
                              child: NewStopWatch(
                                  timeSince,
                                  buttonTextR,
                                  updateRightData,
                                  uploadRightData,
                                  timeSoFarOnRight,
                                  rightSideGoing),
                            )
                          ]),
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

              // History Card - in widgets
              Padding(
                padding: EdgeInsets.only(top:30),
                child: HistoryDropdown(SleepHistoryStream()),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

