import 'package:babysteps/app/pages/tracking/feeding/feeding_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/stopwatch.dart';
import 'dart:core';

class BottleFeedingPage extends StatefulWidget {
  const BottleFeedingPage({super.key});

  @override
  State<BottleFeedingPage> createState() => _BottleFeedingPageState();
}

class _BottleFeedingPageState extends State<BottleFeedingPage> {
  String activeButton = "Breast milk";
  String buttonText = "Bottle";
  String timeSince = "--";
  //Initialization to update the stopwatch
  int timeSoFarInFeed = 0;
  bool stopwatchGoing = false;
  //Id we'll use in the update method so we update the right document
  String? id;

  //Get the data from the database
  Future getData() async {
    ///Get the most recent finished data for the card
    QuerySnapshot finishedBottleQuerySnapshot =
        await FeedingDatabaseMethods().getLatestFinishedBottleEntry();
    //Get the ongoing data for the stopwatch
    QuerySnapshot ongoingBottleQuerySnapshot =
        await FeedingDatabaseMethods().getLatestOngoingBottleEntry();
    //As long as we have data for the most recent finished bottle,
    //we'll want to display the right information
    if (finishedBottleQuerySnapshot.docs.isNotEmpty) {
      try {
        String diff = DateTime.now()
            .difference(DateTime.parse(
                finishedBottleQuerySnapshot.docs[0]['date'].toString()))
            .inMinutes
            .toString();
        timeSince = diff == '1' ? '$diff min' : '$diff mins';
      } catch (error) {
        //If there's an error, print it to the output
        debugPrint(error.toString());
      }
    }
    //If there's an ongoing timer, update the information the stopwatch will need.
    if (ongoingBottleQuerySnapshot.docs.isNotEmpty) {
      //Grab the id so we can update later
      id = ongoingBottleQuerySnapshot.docs[0].id;
      //Grab how much time has already elapsed
      timeSoFarInFeed = DateTime.now()
          .difference(DateTime.parse(
              ongoingBottleQuerySnapshot.docs[0]['date'].toString()))
          .inMilliseconds;
      //set flag that the stopwatch is going
      stopwatchGoing = true;
    }
    if (mounted) {
      setState(() {});
    }
    //Return this simply so the FutureBuilder can show the stopwatch
    return finishedBottleQuerySnapshot;
  }

  //Upload data to the database with default value for length. Note side is in here
  //so the same data is consistent in the feeding database
  //This method will be called when the timer is started
  uploadData() async {
    Map<String, dynamic> uploaddata = {
      'type': 'Bottle',
      'side': '--',
      'length': '--',
      'bottleType': activeButton,
      'active': true,
      'date': DateTime.now().toIso8601String(),
    };

    await FeedingDatabaseMethods().addFeedingEntry(uploaddata);
    //once data has been added, update the card accordingly
  }

  //Update data with the actual feeding length
  //This method will be called when the timer is ended
  updateData(String feedingLength) async {
    if (id != null) {
      await FeedingDatabaseMethods().updateFeedingEntry(feedingLength, id!);
      //once data has been added, update the card accordingly
      bottleDone(feedingLength);
    }
  }

  void bottleTypeClicked(String type) {
    setState(() {
      activeButton = type;
    });
  }

  // Start/stop stopwatch func
  void bottleClicked() {
    setState(() {
      stopwatchGoing = !stopwatchGoing;
    });
  }

 void bottleDone(String bottleLength) {
    setState(() {
      timeSince = "0:00";
      // lastNap = napLength;
    });
    openDialog();
  }

  // Popup text window for bottle quantity
  Future openDialog() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text('How much did baby eat?', style: TextStyle(color: Theme.of(context).colorScheme.onSurface,)),
      content: Row(
        children: [
          Expanded(
            child: TextField(
              keyboardType: TextInputType.number,
              autofocus: true, // Automatically enter the text field and pull up keyboard
              decoration: InputDecoration(hintText: 'Enter quantity')
              ),
          ),
          Text('oz', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))
        ],
      ),
      actions: [
        FilledButton(
          child: Text('Skip'),
          onPressed: skipQuantity,
          ),
        FilledButton(
          child: Text('Save'),
          onPressed: saveQuantity,
        ),
      ]
    )
  );

  void skipQuantity() {
    Navigator.of(context, rootNavigator: true).pop(); // Makes the popup go away
  }
  void saveQuantity() {
    // Store info in database
    Navigator.of(context, rootNavigator: true).pop(); // Makes the popup go away
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Tracking'),
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      body: SingleChildScrollView(
      child:Center(
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
          //Using a future builder (should we be using a stream builder?)
          //This will ensure that we don't put up the stopwatch until we see if the stopwatch should still be going
          //if we get a return from the Future async call, then we'll display the stopwatch,
          //if there is any error, we'll display the message
          //else we'll just show a progress indicator saying that we're retrieving data
          FutureBuilder(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                children = <Widget>[
                  NewStopWatch(timeSince, buttonText, updateData, uploadData,
                      timeSoFarInFeed, stopwatchGoing),
                ];
              } else if (snapshot.hasError) {
                children = <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Color.fromRGBO(244, 67, 54, 1),
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                ];
              } else {
                children = const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Grabbing Data...'),
                  ),
                ];
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              );
            },
          ),
          // NewStopWatch(timeSince, buttonText, updateData, () => {}, 0, false)
        ]),
      ),
      ),
    );
  }
}

class TimeSinceCard extends StatelessWidget {
  const TimeSinceCard(this.timeSince, {super.key});

  final String timeSince;

  @override
  //Not sure what responsive design lexi had in mind here
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double width = screenWidth * 0.9;
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.secondary, // obviously wrong
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minWidth: width, maxWidth: width, minHeight: 90),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Icon(Icons.access_alarm,
                size: 50, color: Theme.of(context).colorScheme.onSecondary),
          ),
          Text(
            'Time since last bottle: $timeSince',
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
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
