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
      home: Scaffold(
        backgroundColor: const Color(0xffb3beb6),
        appBar: AppBar(
          title: const Text('Tracking',
              style: TextStyle(fontSize: 36, color: Colors.black45)),
          backgroundColor: Color(0xFFFFFAF1),
        ),

        body: Center(
          child: Column(children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(32),
              child: Text('Feeding',
                  style: TextStyle(fontSize: 36, color: Color(0xFFFFFAF1))),
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
                         stopwatchGoing ? Color(0xFFFFFAF1) : Color.fromARGB(255, 13, 60, 70), // Background color
                  ),
                  onPressed: bottleClicked,
                  child: Text(stopwatchGoing ? "Stop bottle" : "Start new bottle",
                      style: TextStyle(
                          fontSize: 18, 
                          color: stopwatchGoing ? Color.fromARGB(255, 0, 0, 0) : Color(0xFFFFFAF1)))),
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
        color: Color.fromARGB(255, 13, 60, 70),
        child: SizedBox(
          width: 380,
          height: 90,
          child: Row(mainAxisAlignment:MainAxisAlignment.center, children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: const Icon(Icons.access_alarm, size: 60, color: Color(0xFFFFFAF1)),
            ),
            Text('Time since last bottle: $timeSince',
                  style: const TextStyle(fontSize: 20, color: const Color(0xfffffaf1),),),
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
        width: 180,
        child: FilledButton.tonal(
          onPressed: () => {onPress(buttonText)},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              return activeButton
                  ? const Color(0xFFF2BB9B)
                  : const Color(0xFFFFFAF1);
            }),
            foregroundColor: MaterialStateProperty.resolveWith((states) {
              return const Color.fromARGB(255, 0, 0, 0);
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