import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/stopwatch.dart';
import 'dart:core';

class BreastFeedingPage extends StatefulWidget {
  const BreastFeedingPage({super.key});

  @override
  State<BreastFeedingPage> createState() => _BreastFeedingPageState();
}

class _BreastFeedingPageState extends State<BreastFeedingPage> {
  String timeSince = "8:20";
  String lastSide = "Left";
  String buttonTextL = "left";
  String buttonTextR = "right";
  bool leftSideGoing = false;
  bool rightSideGoing = false;

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
      body: Center(
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
              child: InfoCard(timeSince, lastSide, Theme.of(context)),
            ),

            // Stopwatches and start/stop buttons for left and right
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              SizedBox(
                height: 200,
                width: 195,
                child: NewStopWatch(timeSince, buttonTextL, leftFeedingDone),
              ),
              SizedBox(
                height: 200,
                width: 195,
                child: NewStopWatch(timeSince, buttonTextR, rightFeedingDone),
              )
            ]),
          ],
        ),

        // Done button - stops both timers if going, will log time since
      ),
    );
  }
}

// Displays time since and last side
class InfoCard extends StatelessWidget {
  const InfoCard(this.timeSince, this.lastSide, this.theme, {super.key});

  final String timeSince;
  final String lastSide;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.secondary,
      child: SizedBox(
        width: 360,
        height: 140,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: ListTile(
                leading: Icon(Icons.access_alarm,
                    size: 50, color: theme.colorScheme.onSecondary),
                title: Text(
                  'Time since last fed: $timeSince',
                  style: TextStyle(
                    fontSize: 20,
                    color: theme.colorScheme.onSecondary,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: ListTile(
                leading: Icon(Icons.sync_alt,
                    size: 50, color: theme.colorScheme.onSecondary),
                title: Text('Last side: $lastSide',
                    style: TextStyle(
                      fontSize: 20,
                      color: theme.colorScheme.onSecondary,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
