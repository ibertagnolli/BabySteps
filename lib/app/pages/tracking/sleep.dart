import 'package:babysteps/app/widgets/stopwatch.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'dart:core';
import 'dart:async';

class SleepPage extends StatefulWidget {
  const SleepPage({super.key});

  @override
  State<SleepPage> createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  String timeSinceNap = "4:38";
  String lastNap = "0:55";
  String buttonText = "Nap";
  Stopwatch watch = Stopwatch();
  late Timer timer;
  bool startStop = true;

  String elapsedTime = '';
updateTime(Timer timer) {
    if (watch.isRunning) {
      setState(() {
        print("startstop Inside=$startStop");
        elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
      });
    }
  }

void backButton(){
  startOrStop();
  Navigator.of(context).pop();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Tracking'),
        leading: BackButton(
          onPressed: () => backButton(),
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
         Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Text(elapsedTime, style: TextStyle(fontSize: 25.0)),
          SizedBox(height: 20.0),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
               Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 60,
                width: 220,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor:
                         startStop ?Color.fromARGB(255, 0, 0, 0) : Color(0xFFFFFAF1), // Background color
                  ),
                  onPressed: startOrStop,
                  child: Text(startStop ? "Start $buttonText" : "Stop $buttonText",
                      style: TextStyle(
                          fontSize: 18, 
                          color: startStop ?Color(0xFFFFFAF1) : Color.fromARGB(255, 13, 60, 70)))),
              ),
            ),
            ],
          )
        ],
      ),
    )
        ]),
      ),

    );
  }

startOrStop() {
    if(startStop) {
      startWatch();
    } else {
      //Or update filled card here?
      watch.reset();
      timeSinceNap = "0:00";
      lastNap = elapsedTime.toString();
      stopWatch();
    }
  }

  startWatch() {
    setState(() {
      startStop = false;
      watch.start();
      timer = Timer.periodic(Duration(milliseconds: 100), updateTime);
    });
  }

  stopWatch() {
    setState(() {
      watch.reset();
      startStop = true;
      watch.stop();
      setTime();
      //TODO: Update filled card here
    });
  }
setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    setState(() {
      elapsedTime = transformMilliSeconds(timeSoFar);
      //timeSince = elapsedTime;
      //lastThing = 0:00
    });
  }

  transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }
}