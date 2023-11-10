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
      backgroundColor: const Color(0xffb3beb6),
        appBar: AppBar(
          title: const Text('Tracking', style: TextStyle(fontSize: 36, color: Colors.black45)),
           backgroundColor: Color(0xFFFFFAF1),
        ),
        body: Center(
          child: Column(children: <Widget>[
            const Text('Sleep', style: TextStyle(fontSize: 36, color: Color(0xFFFFFAF1))),
            const FilledCard(),
            Text("$timerData", style: const TextStyle(fontSize: 20, color: Color(0xFFFFFAF1))),
            FilledButton(
               style: FilledButton.styleFrom( backgroundColor:const Color.fromARGB(255, 13, 60, 70), // Background color
  ),
              onPressed: napClicked,
              child: Text("$buttonText",  style: const TextStyle(fontSize: 20, color: Color(0xFFFFFAF1)))
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
    return const SizedBox(
      height: 180,
      child: Card(
        elevation: 0,
        color: Color(0xFFFFFAF1),
        child:  SizedBox(
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
