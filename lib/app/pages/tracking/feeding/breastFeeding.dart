import 'package:babysteps/app/pages/tracking/feeding/feeding_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/stopwatch.dart';
import 'package:babysteps/app/pages/tracking/feeding/breastfeeding_stream.dart';
import 'package:babysteps/app/widgets/history_widgets.dart';
import 'package:babysteps/app/pages/tracking/history_streams.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'dart:core';

class BreastFeedingPage extends StatefulWidget {
  const BreastFeedingPage({super.key});

  @override
  State<BreastFeedingPage> createState() => _BreastFeedingPageState();
}

class _BreastFeedingPageState extends State<BreastFeedingPage> {
  String lastSide = "Left";
  String buttonTextL = "left";
  String buttonTextR = "right";
  bool leftSideGoing = false;
  bool rightSideGoing = false;
  bool timerGoing = false;
  //Ids for the update method so we know what documents we're updating
  String? docId;
  //Inital time on the right and left
  int timeSoFarOnLeft = 0;
  int timeSoFarOnRight = 0;
  Map<String, dynamic>? sideMap;

  //Get the data from the database
  Future getData() async {
    //Get the ongoing data
    QuerySnapshot ongoingBreastFeeding =
        await FeedingDatabaseMethods().getLatestOngoingBreastFeedingEntry();
    //make sure we don't try to access an index that doesn't exist
    if (ongoingBreastFeeding.docs.isNotEmpty) {
      //get the document id so we can update it later
      docId = ongoingBreastFeeding.docs[0].id;
      //calculate the time in miliseconds from the last time the left side was started
      timeSoFarOnLeft =
          ongoingBreastFeeding.docs[0]['side']['left']['duration'];
      timeSoFarOnRight =
          ongoingBreastFeeding.docs[0]['side']['right']['duration'];

      if (ongoingBreastFeeding.docs[0]['side']['left']['lastStart'] != null) {
        timeSoFarOnLeft += DateTime.now()
            .difference((ongoingBreastFeeding.docs[0]['side']['left']
                    ['lastStart'] as Timestamp)
                .toDate())
            .inMilliseconds;
      }
      if (ongoingBreastFeeding.docs[0]['side']['right']['lastStart'] != null) {
        timeSoFarOnRight += DateTime.now()
            .difference((ongoingBreastFeeding.docs[0]['side']['right']
                    ['lastStart'] as Timestamp)
                .toDate())
            .inMilliseconds;
      }

      sideMap = ongoingBreastFeeding.docs[0]['side'];

      //since ongoingLeft isn't empty, the timer is running so set flag accordingly
      leftSideGoing = ongoingBreastFeeding.docs[0]['side']['left']['active'];
      rightSideGoing = ongoingBreastFeeding.docs[0]['side']['right']['active'];
      timerGoing = ongoingBreastFeeding.docs[0]['active'];
    }
    if (mounted) {
      setState(() {});
    }
    //Have a return so that the FutureBuilder in the build knows we've finished
    return ongoingBreastFeeding;
  }

  //Upload the original data, this will be called once the stopwatch is started so we don't know the length yet
  uploadData(String side) async {
    bool leftActive = false;
    bool rightActive = false;
    DateTime? lastLeftStart;
    DateTime? lastRightStart;

    side == 'left' ? leftActive = true : rightActive = true;
    side == 'left'
        ? lastLeftStart = DateTime.now()
        : lastRightStart = DateTime.now();

    Map<String, dynamic> uploaddata = {
      'type': 'BreastFeeding',
      'side': {
        'latest': side == 'left' ? 'left' : 'right',
        'left': {
          'duration': 0,
          'active': leftActive,
          'lastStart': lastLeftStart
        },
        'right': {
          'duration': 0,
          'active': rightActive,
          'lastStart': lastRightStart
        },
      },
      'length': '--',
      'bottleType': '--',
      'active': true,
      'date': DateTime.now(),
    };

    await FeedingDatabaseMethods().addFeedingEntry(uploaddata);
  }

  // 'type': 'BreastFeeding',
  // 'side': {
  //   'left': {'duration': 0, 'active': leftActive},
  //   'right': {'duration': 0, 'active': rightActive}
  // },
  // 'length': '--',
  // 'bottleType': '--',
  // 'active': true,
  // 'date': DateTime.now(),

  //When a stopwatch is clicked, we create entry in the database with the start time
  //When the stopwatch is paused, we update the 'side' entry
  //When the other stopwatch is clicked, we update the latest side to be the one just clicked
  //When 'done' is clicked, we add left and right durations together to get the length (and set active for both to false)

  //Update the right side data, this will happen once the stopwatch is stopped and we'll pass through the new
  //feeding length. The updateFeedingEntry will also set active to false for this document
  // updateEntry(int feedingLength, String side) async {
  //   if (docId != null) {
  //     Map<String, dynamic>? currentSide =
  //         side == 'left' ? sideMap!['left'] : sideMap!['right'];

  //     currentSide?['duration'] = feedingLength;
  //     currentSide?['active'] = !currentSide['active'];

  //     await FeedingDatabaseMethods().updateFeedingEntry(feedingLength.toString(), docId!);
  //     //once data has been added, update the card accordingly
  //   }
  // }

  updateLeftEntry(int feedingLength) async {
    if (docId != null && sideMap != null) {
      Map<String, dynamic> currentSide = sideMap!['left']!;

      if (leftSideGoing) {
        currentSide['duration'] = feedingLength;
        currentSide['active'] = false;
        currentSide['lastStart'] = null;
      } else {
        currentSide['active'] = true;
        currentSide['lastStart'] = DateTime.now();
        sideMap!['latest'] = 'left';
      }

      sideMap!['left'] = currentSide;

      leftSideGoing = !leftSideGoing;

      await FeedingDatabaseMethods().updateFeedingPauseEntry(sideMap, docId!);
      //once data has been added, update the card accordingly
    }
  }

  updateRightEntry(int feedingLength) async {
    if (docId != null && sideMap != null) {
      Map<String, dynamic> currentSide = sideMap!['right']!;

      if (rightSideGoing) {
        currentSide['duration'] = feedingLength;
        currentSide['active'] = false;
        currentSide['lastStart'] = null;
      } else {
        currentSide['active'] = true;
        currentSide['lastStart'] = DateTime.now();
        sideMap!['latest'] = 'right';
      }

      sideMap!['right'] = currentSide;

      rightSideGoing = !rightSideGoing;

      await FeedingDatabaseMethods().updateFeedingPauseEntry(sideMap, docId!);
      //once data has been added, update the card accordingly
    }
  }

  void doneClicked() async {
    if (docId != null && sideMap != null) {
      Map<String, dynamic> leftSide = sideMap!['left']!;
      Map<String, dynamic> rightSide = sideMap!['right']!;

      timeSoFarOnLeft = leftSide['duration'];
      timeSoFarOnRight = rightSide['duration'];

      if (leftSide['lastStart'] != null) {
        timeSoFarOnLeft += DateTime.now()
            .difference((leftSide['lastStart'] as Timestamp).toDate())
            .inMilliseconds;
      }

      if (rightSide['lastStart'] != null) {
        timeSoFarOnRight += DateTime.now()
            .difference((rightSide['lastStart'] as Timestamp).toDate())
            .inMilliseconds;
      }

      leftSide['active'] = false;
      leftSide['lastStart'] = null;
      rightSide['active'] = false;
      rightSide['lastStart'] = null;

      sideMap!['left'] = leftSide;
      sideMap!['right'] = rightSide;

      await FeedingDatabaseMethods().updateFeedingDoneEntry(
          sideMap, (timeSoFarOnLeft + timeSoFarOnRight).toString(), docId!);
      //once data has been added, update the card accordingly
    }

    setState(() {
      leftSideGoing = false;
      rightSideGoing = false;
      timerGoing = false;

      timeSoFarOnLeft = 0;
      timeSoFarOnRight = 0;
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
                      Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 200,
                                  width: 195,
                                  child: NewStopWatch(
                                    buttonTextL,
                                    updateLeftEntry,
                                    uploadData,
                                    timeSoFarOnLeft,
                                    leftSideGoing,
                                    sessionInProgress: timerGoing,
                                  ),
                                ),
                                SizedBox(
                                  height: 200,
                                  width: 195,
                                  child: NewStopWatch(
                                    buttonTextR,
                                    updateRightEntry,
                                    uploadData,
                                    timeSoFarOnRight,
                                    rightSideGoing,
                                    sessionInProgress: timerGoing,
                                  ),
                                )
                              ]),
                          FilledButton(
                            style: FilledButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 13, 60, 70)),
                            onPressed: doneClicked,
                            child: Text(
                              'Done',
                              style: TextStyle(
                                  fontSize: 18, color: Color(0xFFFFFAF1)),
                            ),
                          ),
                        ],
                      )
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
                padding: EdgeInsets.only(top:10),
                child: HistoryDropdown("breastfeeding"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
