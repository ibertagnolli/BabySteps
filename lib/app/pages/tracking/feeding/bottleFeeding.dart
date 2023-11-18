import 'package:flutter/material.dart';
import 'dart:core';

class BottleFeedingPage extends StatefulWidget {
  const BottleFeedingPage({super.key});

  @override
  State<BottleFeedingPage> createState() => _BottleFeedingPageState();
}


class _BottleFeedingPageState extends State<BottleFeedingPage> {
  
  String activeButton = "Breast milk";
  String timeSince = "8:20";
  bool stopwatchGoing = false;

  void bottleTypeClicked(String type) {
    setState(() {
      activeButton = type;
    });
  }

  // Start/stop stopwatch func
  void bottleClicked() {
    setState(() {
      stopwatchGoing = !stopwatchGoing;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottle Feeding',
      theme: Theme.of(context),
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text('Tracking',
              style: TextStyle(fontSize: 36, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),

        body: Center(
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.all(32),
              child: Text('Bottle Feeding',
                  style: TextStyle(fontSize: 36, color: Theme.of(context).colorScheme.onBackground)),
            ),

            // Top card with info
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: TimeSinceCard(timeSince),
            ),

            // Buttons for bottle type
            Row(mainAxisAlignment:MainAxisAlignment.center, children: [
              BottleTypeButton('Breast milk', activeButton.contains("Breast milk"),
                            bottleTypeClicked),
              
              BottleTypeButton('Formula', activeButton.contains("Formula"),
                            bottleTypeClicked)
            ],),

            // Stopwatch
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("(stopwatch)"),
            ),

            // Start/stop button 
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 60,
                width: 220,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor:
                         stopwatchGoing ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.secondary, // Background color
                  ),
                  onPressed: bottleClicked,
                  child: Text(stopwatchGoing ? "Stop bottle" : "Start new bottle",
                      style: TextStyle(
                          fontSize: 18, 
                          color: stopwatchGoing ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSecondary))),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}


class TimeSinceCard extends StatelessWidget {
  const TimeSinceCard(this.timeSince, {super.key});

  final String timeSince;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.secondary, // obviously wrong
        child: SizedBox(
          width: 360,
          height: 90,
          child: Row(mainAxisAlignment:MainAxisAlignment.center, children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.access_alarm, size: 60, color: Theme.of(context).colorScheme.onSecondary),
            ),
            Text('Time since last bottle: $timeSince',
                  style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.onSecondary,),),
          ]),
        ),
      );
  }
}

class BottleTypeButton extends StatelessWidget {
  const BottleTypeButton(this.buttonText, this.activeButton, this.onPress,
      {super.key});
      
  final String buttonText;
  final bool activeButton;
  final void Function(String bottleType) onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: 60,
        width: 160,
        child: FilledButton.tonal(
          onPressed: () => {onPress(buttonText)},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              return activeButton
                  ? Theme.of(context).colorScheme.primary 
                  : Theme.of(context).colorScheme.surface;
            }),
            foregroundColor: MaterialStateProperty.resolveWith((states) {
              return Theme.of(context).colorScheme.onSurface;
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          child: Text(buttonText, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}