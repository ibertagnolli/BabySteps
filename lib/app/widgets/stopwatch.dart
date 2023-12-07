import 'dart:async';

import 'package:flutter/material.dart';

class NewStopWatch extends StatefulWidget {
  const NewStopWatch(this.timeSince, this.buttonText, this.stopwatchFinish,
      {super.key});

  final String timeSince;
  //final String lastThing;
  final String buttonText;
  final void Function(String length) stopwatchFinish;

  @override
  _NewStopWatchState createState() => _NewStopWatchState();
}

class _NewStopWatchState extends State<NewStopWatch> {
  Stopwatch watch = Stopwatch();
  late Timer timer;
  bool startStop = true;

  String elapsedTime = '00:00:00';
  updateTime(Timer timer) {
    if (watch.isRunning) {
      if(mounted){
      setState(() {
        print("startstop Inside=$startStop");
        elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
      });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //access above variables using
    //widget.timeSince;
    String buttonText = widget.buttonText;
    return Container(
      padding: EdgeInsets.all(1.0),
      child: Column(
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(elapsedTime, style: TextStyle(fontSize: 35.0, color: Color(0xFFFFFAF1),)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: SizedBox(
                  height: 60,
                  width: 180,
                  child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: startStop
                            ? Color.fromARGB(255, 13, 60, 70)
                            : Color(0xFFFFFAF1), // Background color
                      ),
                      onPressed: startOrStop,
                      child: Text(
                          startStop ? "Start $buttonText" : "Stop $buttonText",
                          style: TextStyle(
                              fontSize: 18,
                              color: startStop
                                  ? Color(0xFFFFFAF1)
                                  : Color.fromARGB(255, 13, 60, 70)))),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  startOrStop() {
    if (startStop) {
      startWatch();
    } else {
      //Or update filled card here?
      widget.stopwatchFinish(elapsedTime);
      watch.reset();
      stopWatch();
    }
  }

  startWatch() {
    if(mounted){
    setState(() {
      startStop = false;
      watch.start();
      timer = Timer.periodic(Duration(milliseconds: 100), updateTime);
    });
    }
  }

  stopWatch() {
    if(mounted){
    setState(() {
      watch.reset();
      startStop = true;
      watch.stop();
      setTime();
      //TODO: Update filled card here
    });
    }
  }

  setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    if(mounted){
    setState(() {
      elapsedTime = transformMilliSeconds(timeSoFar);
      //timeSince = elapsedTime;
      //lastThing = 0:00
    });
    }
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
