import 'dart:async';

import 'package:babysteps/app/pages/tracking/feeding/feeding_database.dart';
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
        currentSide['lastStart'] = null;
      } else {
        currentSide['active'] = true;
        currentSide['lastStart'] = DateTime.now();
        sideMap!['latest'] = 'left';
      }

      sideMap!['left'] = currentSide;

      await FeedingDatabaseMethods().updateFeedingPauseEntry(sideMap, docId!);
      //once data has been added, update the card accordingly
    }
  }

  updateRightEntry(int feedingLength) async {
    if (docId != null && sideMap != null) {
      Map<String, dynamic> currentSide = sideMap!['right']!;

      if (!rightSideGoing) {
        currentSide['duration'] = feedingLength;
        currentSide['active'] = false;
        currentSide['lastStart'] = null;
      } else {
        currentSide['active'] = true;
        currentSide['lastStart'] = DateTime.now();
        sideMap!['latest'] = 'right';
      }

      sideMap!['right'] = currentSide;

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
      docId = null;
      sideMap = null;

      timeSoFarOnLeft = 0;
      timeSoFarOnRight = 0;
      leftWatch.stop;
      leftWatch.reset();
      rightWatch.stop();
      rightWatch.reset();

      leftElapsedTime = transformMilliSeconds(timeSoFarOnLeft);
      rightElapsedTime = transformMilliSeconds(timeSoFarOnRight);
    });
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

  startSide(bool left) async {
    left ? leftSideGoing = true : rightSideGoing = true;
    if (!timerGoing) {
      bool leftActive = false;
      bool rightActive = false;
      DateTime? lastLeftStart;
      DateTime? lastRightStart;

      left ? leftActive = true : rightActive = true;
      left ? lastLeftStart = DateTime.now() : lastRightStart = DateTime.now();

      docId = await uploadData(left);
      sideMap = {
        'latest': left ? 'left' : 'right',
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
      };
    } else if (left) {
      rightSideGoing = false;
      rightWatch.stop();
      updateLeftEntry(leftWatch.elapsedMilliseconds + timeSoFarOnLeft);
      updateRightEntry(rightWatch.elapsedMilliseconds + timeSoFarOnRight);
    } else if (!left) {
      leftSideGoing = false;
      leftWatch.stop();
      updateLeftEntry(leftWatch.elapsedMilliseconds + timeSoFarOnLeft);
      updateRightEntry(rightWatch.elapsedMilliseconds + timeSoFarOnRight);
    }
    if (mounted) {
      setState(() {
        leftSideGoing;
        rightSideGoing;
        docId;
        timerGoing = true;
        left ? leftWatch.start() : rightWatch.start();
        left
            ? Timer.periodic(const Duration(milliseconds: 100), updateLeftTime)
            : Timer.periodic(
                const Duration(milliseconds: 100), updateRightTime);
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
        startSide(true);
      }
      if (rightSideGoing) {
        startSide(false);
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
            SizedBox(
              height: 200,
              width: 195,
              child: Container(
                padding: EdgeInsets.all(1.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(leftElapsedTime,
                          style: TextStyle(
                            fontSize: 35.0,
                            color: Color(0xFFFFFAF1),
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: SizedBox(
                            height: 60,
                            width: 180,
                            child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: !leftSideGoing
                                      ? Color.fromARGB(255, 13, 60, 70)
                                      : Color(0xFFFFFAF1), // Background color
                                ),
                                onPressed: leftSideGoing
                                    ? () => stopSide(true)
                                    : () => startSide(true),
                                child: Text(
                                    leftSideGoing ? "Stop left" : "Start left",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: !leftSideGoing
                                            ? Color(0xFFFFFAF1)
                                            : Color.fromARGB(
                                                255, 13, 60, 70)))),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 200,
              width: 195,
              child: Container(
                padding: EdgeInsets.all(1.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(rightElapsedTime,
                          style: TextStyle(
                            fontSize: 35.0,
                            color: Color(0xFFFFFAF1),
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: SizedBox(
                            height: 60,
                            width: 180,
                            child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: !rightSideGoing
                                      ? Color.fromARGB(255, 13, 60, 70)
                                      : Color(0xFFFFFAF1), // Background color
                                ),
                                onPressed: rightSideGoing
                                    ? () => stopSide(false)
                                    : () => startSide(false),
                                child: Text(
                                    rightSideGoing
                                        ? "Stop right"
                                        : "Start right",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: !rightSideGoing
                                            ? Color(0xFFFFFAF1)
                                            : Color.fromARGB(
                                                255, 13, 60, 70)))),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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

transformMilliSeconds(int milliseconds) {
  int hundreds = (milliseconds / 10).truncate();
  int seconds = (hundreds / 100).truncate();
  int minutes = (seconds / 60).truncate();
  int hours = (minutes / 60).truncate();

  String hoursStr = (hours % 60).toString().padLeft(2, '0');
  String minutesStr = (minutes % 60).toString().padLeft(2, '0');
  String secondsStr = (seconds % 60).toString().padLeft(2, '0');

  return "$hoursStr:$minutesStr:$secondsStr";
}

//Upload the original data, this will be called once the stopwatch is started so we don't know the length yet
Future<String> uploadData(bool left) async {
  bool leftActive = false;
  bool rightActive = false;
  DateTime? lastLeftStart;
  DateTime? lastRightStart;

  left ? leftActive = true : rightActive = true;
  left ? lastLeftStart = DateTime.now() : lastRightStart = DateTime.now();

  Map<String, dynamic> uploaddata = {
    'type': 'BreastFeeding',
    'side': {
      'latest': left ? 'left' : 'right',
      'left': {'duration': 0, 'active': leftActive, 'lastStart': lastLeftStart},
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

  DocumentReference doc =
      await FeedingDatabaseMethods().addFeedingEntry(uploaddata);

  return doc.id;
}
