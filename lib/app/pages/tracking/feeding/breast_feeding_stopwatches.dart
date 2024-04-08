import 'dart:async';
import 'package:babysteps/app/pages/calendar/notifications.dart';
import 'package:babysteps/app/pages/styles/stopwatch_styles.dart';
import 'package:babysteps/app/pages/tracking/feeding/feeding_database.dart';
import 'package:babysteps/app/widgets/stopwatch.dart';
import 'package:babysteps/main.dart';
import 'package:babysteps/model/baby.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class BreastFeedingStopwatches extends StatefulWidget {
  const BreastFeedingStopwatches(
      this.docId,
      this.timeSoFarOnLeft,
      this.timeSoFarOnRight,
      this.sideMap,
      this.leftSideGoing,
      this.rightSideGoing,
      this.timerGoing,
      {super.key});

  final String? docId;
  final int timeSoFarOnLeft;
  final int timeSoFarOnRight;
  final Map<String, dynamic>? sideMap;
  final bool leftSideGoing;
  final bool rightSideGoing;
  final bool timerGoing;

  @override
  State<BreastFeedingStopwatches> createState() =>
      _BreastFeedingStopwatchesState();
}

class _BreastFeedingStopwatchesState extends State<BreastFeedingStopwatches> {
  Stopwatch leftWatch = Stopwatch();
  Stopwatch rightWatch = Stopwatch();

  String leftElapsedTime = '00:00:00';
  String rightElapsedTime = '00:00:00';

  String? docId;
  int timeSoFarOnLeft = 0;
  int timeSoFarOnRight = 0;
  Map<String, dynamic>? sideMap;
  bool leftSideGoing = false;
  bool rightSideGoing = false;
  bool timerGoing = false;

  updateLeftEntry(int feedingLength) async {
    if (docId != null && sideMap != null) {
      Map<String, dynamic> currentSide = sideMap!['left']!;

      if (!leftSideGoing) {
        currentSide['duration'] = feedingLength;
        currentSide['active'] = false;
        currentSide['lastStart'] = '';
      } else {
        currentSide['active'] = true;
        currentSide['lastStart'] = Timestamp.fromDate(DateTime.now());
        sideMap!['latest'] = 'left';
      }

      sideMap!['left'] = currentSide;

      await FeedingDatabaseMethods().updateFeedingPauseEntry(
          sideMap, docId!, currentUser.value!.currentBaby.value!.collectionId);
      //once data has been added, update the card accordingly
    }
  }

  updateRightEntry(int feedingLength) async {
    if (docId != null && sideMap != null) {
      Map<String, dynamic> currentSide = sideMap!['right']!;

      if (!rightSideGoing) {
        currentSide['duration'] = feedingLength;
        currentSide['active'] = false;
        currentSide['lastStart'] = '';
      } else {
        currentSide['active'] = true;
        currentSide['lastStart'] = Timestamp.fromDate(DateTime.now());
        sideMap!['latest'] = 'right';
      }

      sideMap!['right'] = currentSide;

      await FeedingDatabaseMethods().updateFeedingPauseEntry(
          sideMap, docId!, currentUser.value!.currentBaby.value!.collectionId);
      //once data has been added, update the card accordingly
    }
  }

  void doneClicked() async {
    if (docId != null && sideMap != null) {
      Map<String, dynamic> leftSide = sideMap!['left']!;
      Map<String, dynamic> rightSide = sideMap!['right']!;

      timeSoFarOnLeft = leftSide['duration'];
      timeSoFarOnRight = rightSide['duration'];

      if (leftSide['lastStart'] != '') {
        timeSoFarOnLeft += DateTime.now()
            .difference((leftSide['lastStart'] as Timestamp).toDate())
            .inMilliseconds;
        leftSide['duration'] += DateTime
                .now() // Lexie added so side time is updated when done clicked
            .difference((leftSide['lastStart'] as Timestamp).toDate())
            .inMilliseconds;
      }

      if (rightSide['lastStart'] != '') {
        timeSoFarOnRight += DateTime.now()
            .difference((rightSide['lastStart'] as Timestamp).toDate())
            .inMilliseconds;
        rightSide['duration'] += DateTime
                .now() // Lexie added so side time is updated when done clicked
            .difference((rightSide['lastStart'] as Timestamp).toDate())
            .inMilliseconds;
      }

      leftSide['active'] = false;
      leftSide['lastStart'] = '';
      rightSide['active'] = false;
      rightSide['lastStart'] = '';

      sideMap!['left'] = leftSide;
      sideMap!['right'] = rightSide;

      await FeedingDatabaseMethods().updateFeedingDoneEntry(
          sideMap,
          timeSoFarOnLeft + timeSoFarOnRight,
          docId!,
          currentUser.value!.currentBaby.value!.collectionId);
      //once data has been added, update the card accordingly
    }

    setState(() {
      leftSideGoing = false;
      rightSideGoing = false;
      timerGoing = false;
      docId = null;
      sideMap = null;

      timeSoFarOnLeft = 0;
      timeSoFarOnRight = 0;
      leftWatch.stop();
      leftWatch.reset();
      rightWatch.stop();
      rightWatch.reset();

      leftElapsedTime = transformMilliSeconds(timeSoFarOnLeft);
      rightElapsedTime = transformMilliSeconds(timeSoFarOnRight);
    });

    //Schedule notification for reminder in 2 hours 
    var today = DateTime.now();
    var twoHours = today.hour + 2;
     NotificationService().scheduleNotification(
            id: 0,
            title: "Breastfeeding Reminder",
            body: "Its been 2 hours since you last fed ${currentUser.value?.currentBaby.value?.name}"
                '$twoHours:${today.minute}',
            scheduledNotificationDateTime: DateTime(
                today.year,
                today.month,
                today.day,
                twoHours,
                today.minute));
  }

  updateLeftTime(Timer timer) {
    if (leftWatch.isRunning) {
      if (mounted) {
        setState(() {
          int totalElapsed = leftWatch.elapsedMilliseconds + timeSoFarOnLeft;
          leftElapsedTime = transformMilliSeconds(totalElapsed);
        });
      }
    }
  }

  updateRightTime(Timer timer) {
    if (rightWatch.isRunning) {
      if (mounted) {
        setState(() {
          int totalElapsed = rightWatch.elapsedMilliseconds + timeSoFarOnRight;
          rightElapsedTime = transformMilliSeconds(totalElapsed);
        });
      }
    }
  }

  stopSide(bool left) {
    if (mounted) {
      setState(() {
        left ? leftSideGoing = false : rightSideGoing = false;
        left ? leftWatch.stop() : rightWatch.stop();
        left
            ? updateLeftEntry(leftWatch.elapsedMilliseconds + timeSoFarOnLeft)
            : updateRightEntry(
                rightWatch.elapsedMilliseconds + timeSoFarOnRight);
      });
    }
  }

  startLeftSide() async {
    leftSideGoing = true;
    if (!timerGoing) {
      sideMap = {
        'latest': 'left',
        'left': {
          'duration': 0,
          'active': true,
          'lastStart': Timestamp.fromDate(DateTime.now()),
        },
        'right': {
          'duration': 0,
          'active': false,
          'lastStart': '',
        },
      };
      docId = await uploadData(sideMap!);
    } else {
      rightSideGoing = false;
      rightWatch.stop();
      updateLeftEntry(leftWatch.elapsedMilliseconds + timeSoFarOnLeft);
      updateRightEntry(rightWatch.elapsedMilliseconds + timeSoFarOnRight);
    }
    if (mounted) {
      setState(() {
        timerGoing = true;
        leftWatch.start();
        Timer.periodic(const Duration(milliseconds: 100), updateLeftTime);
      });
    }
  }

  startRightSide() async {
    rightSideGoing = true;
    if (!timerGoing) {
      sideMap = {
        'latest': 'right',
        'left': {
          'duration': 0,
          'active': false,
          'lastStart': '',
        },
        'right': {
          'duration': 0,
          'active': true,
          'lastStart': Timestamp.fromDate(DateTime.now()),
        },
      };
      docId = await uploadData(sideMap!);
    } else {
      leftSideGoing = false;
      leftWatch.stop();
      updateLeftEntry(leftWatch.elapsedMilliseconds + timeSoFarOnLeft);
      updateRightEntry(rightWatch.elapsedMilliseconds + timeSoFarOnRight);
    }
    if (mounted) {
      setState(() {
        timerGoing = true;
        rightWatch.start();
        Timer.periodic(const Duration(milliseconds: 100), updateRightTime);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      docId = widget.docId;
      timeSoFarOnLeft = widget.timeSoFarOnLeft;
      timeSoFarOnRight = widget.timeSoFarOnRight;
      sideMap = widget.sideMap;
      leftSideGoing = widget.leftSideGoing;
      rightSideGoing = widget.rightSideGoing;
      timerGoing = widget.timerGoing;

      leftElapsedTime = transformMilliSeconds(timeSoFarOnLeft);
      rightElapsedTime = transformMilliSeconds(timeSoFarOnRight);

      if (leftSideGoing) {
        startLeftSide();
      }
      if (rightSideGoing) {
        startRightSide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left timer
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 200,
                width: 195,
                child: Container(
                  padding: const EdgeInsets.all(1.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          leftElapsedTime,
                          style: timerText(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: SizedBox(
                              height: 60,
                              width: 180, // TODO make fraction of screen size?
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                    backgroundColor: buttonColor(leftSideGoing)),
                                onPressed: leftSideGoing
                                    ? () => stopSide(true)
                                    : () => startLeftSide(),
                                child: Text(
                                  leftSideGoing ? "Stop left" : "Start left",
                                  style: buttonTextStyle(leftSideGoing),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            
            // Right timer
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 200,
                width: 195,
                child: Container(
                  padding: const EdgeInsets.all(1.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(rightElapsedTime, style: timerText()),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: SizedBox(
                              height: 60,
                              width: 180, // TODO make fraction of screen size?
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: buttonColor(rightSideGoing),
                                ),
                                onPressed: rightSideGoing
                                    ? () => stopSide(false)
                                    : () => startRightSide(),
                                child: Text(
                                  rightSideGoing ? "Stop right" : "Start right",
                                  style: buttonTextStyle(rightSideGoing),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
          ],
        ),
        
        // Done button
        FilledButton(
          style: FilledButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 13, 60, 70)),
          onPressed: doneClicked,
          child: const Text('Done',
              style: TextStyle(fontSize: 18, color: Color(0xFFFFFAF1))),
        )
      ],
    );
  }
}

//Upload the original data, this will be called once the session is started
Future<String> uploadData(Map<String, dynamic> side) async {
  Map<String, dynamic> uploaddata = {
    'type': 'BreastFeeding',
    'side': side,
    'length': 0,
    'active': true,
    'ounces': '--',
    'date': DateTime.now(),
  };

  DocumentReference doc = await FeedingDatabaseMethods().addFeedingEntry(
      uploaddata, currentUser.value!.currentBaby.value!.collectionId);

  return doc.id;
}
