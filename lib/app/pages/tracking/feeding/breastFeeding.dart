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
  String lastSide = "left";
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
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Breast Feeding',
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
              child: Text('Breast Feeding',
                  style: TextStyle(fontSize: 36, color: Color(0xFFFFFAF1))),
            ),

            // Top card with info 
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: InfoCard(timeSince, lastSide),
            ),

            // Stopwatches and start/stop buttons for left and right
              // Left 
                  // Stopwatch 
                  Column(children:[
                   SizedBox(
                    height: 200,
                    width: 300, 
                    child: NewStopWatch(timeSince, buttonTextL),
                  ),
            ]),
                  // Right
                    // Stopwatch  
                  Column(children:[
                   SizedBox(
                    height: 200,
                    width: 300, 
                    child: NewStopWatch(timeSince, buttonTextR),
                  )
                  ])
                ],
            ),

            // Done button - stops both timers if going, will log time since 
          
         
        ),
      ),
    );
  }
}

// Displays time since and last side
class InfoCard extends StatelessWidget {
  const InfoCard(this.timeSince, this.lastSide, {super.key});

  final String timeSince;
  final String lastSide;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        color: Color.fromARGB(255, 13, 60, 70),
        child: SizedBox(
          width: 360,
          height: 150,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: ListTile(
                    leading: const Icon(Icons.access_alarm, size: 50, color: Color(0xFFFFFAF1)),
                    title: 
                      Text('Time since last fed: $timeSince',
                      style: const TextStyle(fontSize: 20, color: const Color(0xfffffaf1),),),
                  ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child:
                  ListTile(
                    leading: const Icon(Icons.sync_alt, size: 50, color: Color(0xFFFFFAF1)),
                    title:
                        Text('Last side: $lastSide', 
                        style: const TextStyle(fontSize: 20, color: const Color(0xfffffaf1),)),
                    // tileColor: ,
                  ),
              ),
            ],
          ),
        ),
      );
  }
}

