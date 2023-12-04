import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:core';

class BottleFeedingPage extends StatefulWidget {
  const BottleFeedingPage({super.key});

  @override
  State<BottleFeedingPage> createState() => _BottleFeedingPageState();
}

class _BottleFeedingPageState extends State<BottleFeedingPage> {
  String activeButton = "Breast milk";
  String buttonText = "Bottle";
  String timeSince = "8:20";
  Stopwatch watch = Stopwatch();
  late Timer timer;
  bool startStop = true;
  String elapsedTime = '';

//while the timer is running update the screen to show that time.
updateTime(Timer timer) {
    if (watch.isRunning) {
      setState(() {
        print("startstop Inside=$startStop");
        elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
      });
    }
  }
//If we go back in the navigation stop the timer
//TODO: add logic here that will start timer at same time again
void backButton(){
  watch.stop();
  Navigator.of(context).pop();
}
  void bottleTypeClicked(String type) {
    setState(() {
      activeButton = type;
    });
  }

  // Start/stop stopwatch func
  void bottleClicked() {
    setState(() {
      startStop = !startStop;
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
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(32),
            child: Text('Bottle Feeding',
                style: TextStyle(
                    fontSize: 36,
                    color: Theme.of(context).colorScheme.onBackground)),
          ),

          // Top card with info
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: TimeSinceCard(timeSince),
          ),

          // Buttons for bottle type
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BottleTypeButton('Breast milk',
                  activeButton.contains("Breast milk"), bottleTypeClicked),
              BottleTypeButton('Formula', activeButton.contains("Formula"),
                  bottleTypeClicked)
            ],
          ),
          //This container is the stopwatch widget stuff. 
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
  //Start or stop the stopwatch based on the button 
   startOrStop() {
    if(startStop) {
      startWatch();
    } else {
      //Or update filled card here?
      watch.reset();
      timeSince= "0:00";
      //lastNap = elapsedTime.toString();
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

class TimeSinceCard extends StatelessWidget {
  const TimeSinceCard(this.timeSince, {super.key});

  final String timeSince;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.secondary, // obviously wrong
      child: SizedBox(
        width: 360,
        height: 90,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.access_alarm,
                size: 60, color: Theme.of(context).colorScheme.onSecondary),
          ),
          Text(
            'Time since last bottle: $timeSince',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ]),
      ),
    );
  }
}

class BottleTypeButton extends StatelessWidget {
  const BottleTypeButton(this.buttonText, this.activeButton, this.onPress,
      {super.key});

  final String buttonText;
  final bool activeButton;
  final void Function(String bottleType) onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: 60,
        width: 160,
        child: FilledButton.tonal(
          onPressed: () => {onPress(buttonText)},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              return activeButton
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface;
            }),
            foregroundColor: MaterialStateProperty.resolveWith((states) {
              return Theme.of(context).colorScheme.onSurface;
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          child: Text(buttonText, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
