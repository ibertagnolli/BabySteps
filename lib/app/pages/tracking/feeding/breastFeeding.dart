import 'package:babysteps/app/pages/tracking/feeding/breast_feeding_stopwatches.dart';
import 'package:babysteps/app/pages/tracking/feeding/feeding_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/pages/tracking/feeding/breastfeeding_stream.dart';
import 'package:babysteps/app/widgets/history_widgets.dart';
import 'dart:core';

class BreastFeedingPage extends StatefulWidget {
  const BreastFeedingPage({super.key});

  @override
  State<BreastFeedingPage> createState() => _BreastFeedingPageState();
}

class _BreastFeedingPageState extends State<BreastFeedingPage> {
  String? docId;
  int timeSoFarOnLeft = 0;
  int timeSoFarOnRight = 0;
  Map<String, dynamic>? sideMap;
  bool leftSideGoing = false;
  bool rightSideGoing = false;
  bool timerGoing = false;

//Get the data from the database
  Future getData() async {
    //Get the ongoing data
    QuerySnapshot ongoingBreastFeeding =
        await FeedingDatabaseMethods().getLatestOngoingBreastFeedingEntry();
    //make sure we don't try to access an index that doesn't exist
    if (ongoingBreastFeeding.docs.isNotEmpty) {
      //get the document id so we can update it later
      leftId = ongoingLeftBreastFeedingQuerySnapshot.docs[0].id;
      //calculate the time in miliseconds from the last time the left side was started
      timeSoFarOnLeft = DateTime.now()
          .difference(
              ongoingLeftBreastFeedingQuerySnapshot.docs[0]['date'].toDate())
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
          .difference(
              (ongoingRightBreastFeedingQuerySnapshot.docs[0]['date'].toDate()))
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
      'ounces': '--',
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
      'ounces': '--',
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
              FutureBuilder(
                future: getData(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    children = <Widget>[
                      Column(
                        children: [
                          BreastFeedingStopwatches(
                            docId,
                            timeSoFarOnLeft,
                            timeSoFarOnRight,
                            sideMap,
                            leftSideGoing,
                            rightSideGoing,
                            timerGoing,
                          )
                        ],
                      )
                    ];
                  } else if (snapshot.hasError) {
                    children = errorMessage(snapshot.error.toString());
                  } else {
                    children = progressIndicator();
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
                padding: EdgeInsets.only(top: 10),
                child: HistoryDropdown("breastfeeding"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Widget> progressIndicator() {
  return const [
    SizedBox(
      width: 60,
      height: 60,
      child: CircularProgressIndicator(),
    ),
    Padding(
      padding: EdgeInsets.only(top: 16),
      child: Text('Grabbing Data...'),
    )
  ];
}

List<Widget> errorMessage(String message) {
  return [
    const Icon(
      Icons.error_outline,
      color: Color.fromRGBO(244, 67, 54, 1),
      size: 60,
    ),
    Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text('Error: $message'),
    )
  ];
}
