import 'package:babysteps/app/widgets/stopwatch.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'dart:core';

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
    return MaterialApp(
      title: 'Sleep',
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
              child: Text('Sleep',
                  style: TextStyle(fontSize: 36, color: Color(0xFFFFFAF1))),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: FilledCard("last nap: $timeSinceNap",
                      "nap: $lastNap", Icon(Icons.person_search_sharp)),
            ),
      
         //TODO: pass time since strings to the stopwatch widget!!
            NewStopWatch(timeSinceNap, buttonText),
          ]),
        ),
      ),
    );
  }
}


