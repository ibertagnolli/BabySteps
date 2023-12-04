import 'package:babysteps/app/widgets/stopwatch.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'dart:core';
//To use the old way stopwatch, just call NewStopWatch(timeSince, ButtonText)
// with the time since for the card and then the text you want on the button and it will make that in the stopwatch widget. 
class SleepPage extends StatefulWidget {
  const SleepPage({super.key});

  @override
  State<SleepPage> createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  String timeSinceNap = "4:38";
  String lastNap = "0:55";
  String buttonText = "Nap";

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
            child: Text('Sleep',
                style: TextStyle(
                    fontSize: 36,
                    color: Theme.of(context).colorScheme.onBackground)),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: FilledCard("last nap: $timeSinceNap", "nap: $lastNap",
                Icon(Icons.person_search_sharp)),
          ),

          //TODO: pass time since strings to the stopwatch widget!!
          NewStopWatch(timeSinceNap, buttonText),
        ]),
      ),
    );
  }
}
