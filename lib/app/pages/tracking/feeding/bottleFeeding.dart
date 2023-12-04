import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/stopwatch.dart';
import 'dart:core';
//To use the old way stopwatch, just call NewStopWatch(timeSince, ButtonText)
// with the time since for the card and then the text you want on the button and it will make that in the stopwatch widget. 
class BottleFeedingPage extends StatefulWidget {
  const BottleFeedingPage({super.key});

  @override
  State<BottleFeedingPage> createState() => _BottleFeedingPageState();
}

class _BottleFeedingPageState extends State<BottleFeedingPage> {
  String activeButton = "Breast milk";
  String buttonText = "Bottle";
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
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(32),
            child: Text('Bottle Feeding',
                style: TextStyle(
                    fontSize: 36,
                    color: Theme.of(context).colorScheme.onBackground)),
          ),

          // Top card with info
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: TimeSinceCard(timeSince),
          ),

          // Buttons for bottle type
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BottleTypeButton('Breast milk',
                  activeButton.contains("Breast milk"), bottleTypeClicked),
              BottleTypeButton('Formula', activeButton.contains("Formula"),
                  bottleTypeClicked)
            ],
          ),
          NewStopWatch(timeSince, buttonText)
        ]),
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
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.access_alarm,
                size: 60, color: Theme.of(context).colorScheme.onSecondary),
          ),
          Text(
            'Time since last bottle: $timeSince',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
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
