import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:async';


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
  Stopwatch watchLeft = Stopwatch();
  Stopwatch watchRight = Stopwatch();
  //Stopwatch watch = Stopwatch();
  late Timer timer;
  bool startStop = true;
  String elapsedTimeLeft = '';
  String elapsedTimeRight = '';
//while the timer is running update the screen to show that time.
updateTime(Timer timer) {
    if (watchLeft.isRunning) {
      setState(() {
        print("startstop Inside=$startStop");
        elapsedTimeLeft = transformMilliSeconds(watchLeft.elapsedMilliseconds);
      });
    }
    if (watchRight.isRunning) {
      setState(() {
        print("startstop Inside=$startStop");
        elapsedTimeRight = transformMilliSeconds(watchRight.elapsedMilliseconds);
      });
    }
  }
//If we go back in the navigation stop the timer
//TODO: add logic here that will start timer at same time again
void backButton(){
  //watch.stop();
  watchLeft.stop();
  watchRight.stop();
  Navigator.of(context).pop();
}

  void leftSideClicked() {
    setState(() {
      leftSideGoing = !leftSideGoing;
      startOrStop(leftSideGoing, watchLeft);
      //  watchLeft.start();
      updateTime(timer);
      //startOrStop();
    });
  }

  void rightSideClicked() {
    setState(() {
      rightSideGoing = !rightSideGoing;
      startOrStop(rightSideGoing, watchRight);
      // watchRight.start();
      // updateTime(timer, watchRight);
    
    });
  }

  void doneClicked() {
    setState(() {
      leftSideGoing = false;
      rightSideGoing = false;
      watchLeft.stop();
      watchRight.stop();
      timeSince = "0:00:00";
      // Reset time since last feed
    });
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
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(32),
              child: Text('Breast Feeding',
                  style: TextStyle(
                      fontSize: 36,
                      color: Theme.of(context).colorScheme.onBackground)),
            ),

            // Top card with info
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: InfoCard(timeSince, lastSide, Theme.of(context)),
            ),

             // Stopwatches and start/stop buttons for left and right
            Row(mainAxisAlignment:MainAxisAlignment.center, children: [
              // Left
              Column(
                children: [
                  // Stopwatch
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Text(elapsedTimeLeft),
                  ),
                  // Start/stop button 
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 60,
                      width: 150,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              leftSideGoing ? Color(0xFFF2BB9B) : Color(0xFFFFFAF1), // Background color
                        ),
                        onPressed: leftSideClicked,
                        child: Text(leftSideGoing ? "Stop left" : "Start left",
                            style: TextStyle(
                                fontSize: 18, 
                                color: Color.fromARGB(255, 0, 0, 0) ))),
                    ),
                  ),
                ],
              ),
              // Right 
              Column(
                children: [
                  // Stopwatch 
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Text(elapsedTimeRight),
                  ),
                  // Start/stop button 
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 60,
                      width: 150,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              rightSideGoing ? Color(0xFFF2BB9B) : Color(0xFFFFFAF1), // Background color
                        ),
                        onPressed: rightSideClicked, // startOrStop(rightSideGoing, watchRight),
                        child: Text(rightSideGoing ? "Stop right" : "Start right",
                            style: TextStyle(
                                fontSize: 18, 
                                color: Color.fromARGB(255, 0, 0, 0) ))),
                    ),
                  ),
                ],
              )
            ],),

            // Done button - stops both timers if going, will log time since 
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: SizedBox(
                height: 60,
                width: 200,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 13, 60, 70), 
                  ),
                  onPressed: doneClicked,
                  child: Text("We're done!",
                      style: TextStyle(
                          fontSize: 18, 
                          color: Color(0xFFFFFAF1)))),
              ),
            ),
          ]),
        ),
    );
  }

  //Start or stop the stopwatch based on the button 
   startOrStop( bool startStop, Stopwatch watch) {
    if(startStop) {
      startWatch(startStop, watch);
    } else {
      //Or update filled card here?
      watch.reset();
      timeSince= "0:00";
      //lastNap = elapsedTime.toString();
      stopWatch(startStop, watch);
    }
  }

  startWatch(bool startStop, Stopwatch watch) {
    setState(() {
      startStop = false;
      watch.start();
      timer = Timer.periodic(Duration(milliseconds: 100), updateTime);
    });
  }

  stopWatch(bool startStop, Stopwatch watch) {
    setState(() {
      watch.reset();
      startStop = true;
      watch.stop();
      setTime(watch);
    });
  }
//TODO: Send reads and writes, fix logic to get which watch.
setTime(Stopwatch watch) {
   // var timeSoFar = watch.elapsedMilliseconds;
    setState(() {
     // elapsedTimeLeft = transformMilliSeconds(timeSoFar);
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

// Displays time since and last side
class InfoCard extends StatelessWidget {
  const InfoCard(this.timeSince, this.lastSide, this.theme, {super.key});

  final String timeSince;
  final String lastSide;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.secondary,
      child: SizedBox(
        width: 360,
        height: 150,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: ListTile(
                leading: Icon(Icons.access_alarm,
                    size: 50, color: theme.colorScheme.onSecondary),
                title: Text(
                  'Time since last fed: $timeSince',
                  style: TextStyle(
                    fontSize: 20,
                    color: theme.colorScheme.onSecondary,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: ListTile(
                leading: Icon(Icons.sync_alt,
                    size: 50, color: theme.colorScheme.onSecondary),
                title: Text('Last side: $lastSide',
                    style: TextStyle(
                      fontSize: 20,
                      color: theme.colorScheme.onSecondary,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
