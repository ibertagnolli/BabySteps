import 'package:flutter/material.dart';
import 'dart:core';

class BreastFeedingPage extends StatefulWidget {
  const BreastFeedingPage({super.key});

  @override
  State<BreastFeedingPage> createState() => _BreastFeedingPageState();
}


class _BreastFeedingPageState extends State<BreastFeedingPage> {
  
  String timeSince = "8:20";
  String lastSide = "left";
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
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Breast Feeding',
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text('Tracking',
              style: TextStyle(fontSize: 36, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          backgroundColor: Theme.of(context).colorScheme.surface,
          leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
            color: Theme.of(context).colorScheme.onSurface,
          ),

        ),

        body: Center(
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.all(32),
              child: Text('Breast Feeding',
                  style: TextStyle(fontSize: 36, color: Theme.of(context).colorScheme.onBackground)),
            ),

            // Top card with info 
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: InfoCard(timeSince, lastSide, Theme.of(context)),
            ),

            // Stopwatches and start/stop buttons for left and right
            Row(mainAxisAlignment:MainAxisAlignment.center, children: [
              // Left
              Column(
                children: [
                  // Stopwatch
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Text("(stopwatch)"),
                  ),
                  // Start/stop button 
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 60,
                      width: 150,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              leftSideGoing ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface, // Background color
                        ),
                        onPressed: leftSideClicked,
                        child: Text(leftSideGoing ? "Stop left" : "Start left",
                            style: TextStyle(
                                fontSize: 18, 
                                color: Theme.of(context).colorScheme.onSurface ))),
                    ),
                  ),
                ],
              ),
              // Right 
              Column(
                children: [
                  // Stopwatch 
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Text("(stopwatch)"),
                  ),
                  // Start/stop button 
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 60,
                      width: 150,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              rightSideGoing ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface, // Background color
                        ),
                        onPressed: rightSideClicked,
                        child: Text(rightSideGoing ? "Stop right" : "Start right",
                            style: TextStyle(
                                fontSize: 18, 
                                color: Theme.of(context).colorScheme.onSurface ))),
                    ),
                  ),
                ],
              )
            ],),

            // Done button - stops both timers if going, will log time since 
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: SizedBox(
                height: 60,
                width: 200,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary, 
                  ),
                  onPressed: doneClicked,
                  child: Text("We're done!",
                      style: TextStyle(
                          fontSize: 18, 
                          color: Theme.of(context).colorScheme.onSecondary))),
              ),
            ),
          ]),
        ),
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
          height: 150,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: ListTile(
                    leading: Icon(Icons.access_alarm, size: 50, color: theme.colorScheme.onSecondary),
                    title: 
                      Text('Time since last fed: $timeSince',
                      style: TextStyle(fontSize: 20, color: theme.colorScheme.onSecondary,),),
                  ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child:
                  ListTile(
                    leading: Icon(Icons.sync_alt, size: 50, color: theme.colorScheme.onSecondary),
                    title:
                        Text('Last side: $lastSide', 
                        style: TextStyle(fontSize: 20, color: theme.colorScheme.onSecondary,)),
                  ),
              ),
            ],
          ),
        ),
      );
  }
}

