import 'dart:async';

import 'package:flutter/material.dart';

class NewStopWatch extends StatefulWidget {
  const NewStopWatch(this.buttonText, this.stopwatchUpdate, this.stopwatchBegin,
      this.timeAlreadyElapsed, this.timerOngoing,
      {this.sessionInProgress = false, super.key});

  //final String lastThing;
  final String buttonText;
  final void Function(int length) stopwatchUpdate;
  final void Function(String side) stopwatchBegin;
  final int timeAlreadyElapsed;
  final bool timerOngoing;
  final bool sessionInProgress;

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
  bool startStop = true;

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

    setState(() {
      elapsedTime = transformMilliSeconds(initTime);
    });

    //if we have an ongoing timer on intialization, start the timer
    //so it looks like its continuing from where it left off
    if (widget.timerOngoing) {
      startOrStop();
    }
  }

  @override
  Widget build(BuildContext context) {
    //access above variables using
    String buttonText = widget.buttonText;
    return Container(
      padding: EdgeInsets.all(1.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(elapsedTime,
                style: TextStyle(
                  fontSize: 35.0,
                  color: Color(0xFFFFFAF1),
                )),
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
      //If the timer hasn't been started yet, call the passed through method to begin a timer
      if (!widget.sessionInProgress) {
        widget.stopwatchBegin(widget.buttonText);
      } else if (!widget.timerOngoing) {
        widget.stopwatchUpdate(watch.elapsedMilliseconds + initTime);
      }
      startWatch();
    } else {
      //Or update filled card here?
      widget.stopwatchUpdate(watch.elapsedMilliseconds + initTime);
      // watch.reset();
      stopWatch();
    }
  }

  startWatch() {
    if (mounted) {
      setState(() {
        startStop = false;
        watch.start();
        timer = Timer.periodic(Duration(milliseconds: 100), updateTime);
      });
    }
  }

  stopWatch() {
    if (mounted) {
      setState(() {
        // watch.reset();
        startStop = true;
        watch.stop();
        // setTime();
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
