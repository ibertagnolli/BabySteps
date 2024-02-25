import 'dart:async';

import 'package:babysteps/app/pages/styles/stopwatch_styles.dart';
import 'package:flutter/material.dart';

class NewStopWatch extends StatefulWidget {
  NewStopWatch(this.buttonText, this.stopwatchFinish, this.stopwatchBegin,
      this.timeAlreadyElapsed, this.timerOngoing,
      {super.key});

  //final String lastThing;
  final String buttonText;
  final void Function(String length) stopwatchFinish;
  final void Function() stopwatchBegin;
  final int timeAlreadyElapsed;
  bool timerOngoing;

//TODO: figure out the better way to pass the inital timeAlreadyElapsed, if grabbed via
//widget.timeAlreadyElapsed, it continues to increase making the time funky.
  @override
  _NewStopWatchState createState() => _NewStopWatchState(timeAlreadyElapsed);
}

class _NewStopWatchState extends State<NewStopWatch> {
  int initTime;
  _NewStopWatchState(this.initTime);
  Stopwatch watch = Stopwatch();
  late Timer timer;
  bool timerStopped = true;
  bool? timerOngoing;

  String elapsedTime = '00:00:00';
  updateTime(Timer timer) {
    if (watch.isRunning) {
      if (mounted) {
        setState(() {
          // print("startstop Inside=$startStop");
          int totalElapsed = watch.elapsedMilliseconds + initTime;
          elapsedTime = transformMilliSeconds(totalElapsed);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    //if we have an ongoing timer on intialization, start the timer
    //so it looks like its continuing from where it left off
    timerOngoing = widget.timerOngoing;
    if (timerOngoing!) {
      startOrStop();
    }
  }

  @override
  Widget build(BuildContext context) {
    //access above variables using
    String buttonText = widget.buttonText;
    return Container(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              elapsedTime,
              style: timerText(),
            ),
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
                      backgroundColor: buttonColor(!timerStopped),
                    ),
                    onPressed: startOrStop,
                    child: Text(
                      timerStopped ? "Start $buttonText" : "Stop $buttonText",
                      style: buttonTextStyle(!timerStopped),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  startOrStop() {
    if (timerStopped) {
      //If the timer hasn't been started yet, call the passed through method to begin a timer
      if (!timerOngoing!) widget.stopwatchBegin();
      startWatch();
    } else {
      //Or update filled card here?
      widget.stopwatchFinish(elapsedTime);
      // watch.reset();
      stopWatch();
    }
  }

  startWatch() {
    if (mounted) {
      setState(() {
        timerOngoing = true;
        timerStopped = false;
        watch.start();
        timer = Timer.periodic(Duration(milliseconds: 100), updateTime);
      });
    }
  }

  stopWatch() {
    if (mounted) {
      setState(() {
        // watch.reset();
        timerStopped = true;
        timerOngoing = false;
        watch.stop();
        watch.reset();

        setTime();
        //TODO: Update filled card here
      });
    }
  }

  setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    if (mounted) {
      setState(() {
        elapsedTime = transformMilliSeconds(timeSoFar);
      });
    }
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
