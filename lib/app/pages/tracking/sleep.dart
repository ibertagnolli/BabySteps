import 'package:flutter/material.dart';
import 'dart:core';

class SleepPage extends StatefulWidget {
  const SleepPage({super.key});

  @override
  State<SleepPage> createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  //final stopWatch = Stopwatch();
  String timerData = "0:00";
  String buttonText = "Start Nap";
  bool buttonToggled = false; 

  void napClicked() {
    setState(() {
      // timerData = stopWatch.elapsedMilliseconds;
      // print(stopWatch.elapsedMilliseconds); // 0
      // stopWatch.start();
      buttonToggled = true; 
      timerData = "0:01";
      buttonText = "Stop Nap";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sleep Page'),
        ),
        body: Center(
          child: Column(children: <Widget>[
            const Text('Sleep'),
            const FilledCard(),
            Text("$timerData"),
            FilledButton(
              onPressed: napClicked,
              child: Text("$buttonText"),
            ),
          ]),
        ),
      ),
    );
  }
}

class FilledCard extends StatelessWidget {
  const FilledCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.primary,
        child: const SizedBox(
          width: 300,
          height: 100,
          child: Column(children: <Widget>[
            ListTile(
              title: Text('Time Since Last Nap: 1:28'),
              // tileColor: ,
            ),
            Divider(height: 0),
            ListTile(
              title: Text('Last Nap Length: 0:55'),
              // tileColor: ,
            ),
            Divider(height: 0),
            ListTile(
              title: Text('Notes'),
              // tileColor: ,
            ),
          ]),
        ),
      ),
    );
  }
}
