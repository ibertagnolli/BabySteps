import 'package:babysteps/app/pages/tracking/feeding/feeding_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'dart:core';

import 'package:go_router/go_router.dart';

class FeedingPage extends StatefulWidget {
  const FeedingPage({super.key});

  @override
  State<FeedingPage> createState() => _FeedingPageState();
}

class _FeedingPageState extends State<FeedingPage> {
  //Set the inital state to nothing, that way if the user doesn't have any data yet, they can see that indication
  String lastTimeFed = "--";
  String lastFeedingType = "--";
  String lastBreastSide = "--";
  String lastBottleAmount = "--";

  //Get the data from the database
  getData() async {
    //Get the latest finished information in general, and between breastfeeding and bottle so we can update the cards
    QuerySnapshot feedingQuerySnapshot =
        await FeedingDatabaseMethods().getLatestFeedingEntry();
    QuerySnapshot breastFeedingQuerySnapshot =
        await FeedingDatabaseMethods().getLatestFinishedBreastFeedingEntry();
    QuerySnapshot bottleQuerySnapshot =
        await FeedingDatabaseMethods().getLatestFinishedBottleEntry();

    //Ensure we have data first so we don't try to access something we can't
    if (feedingQuerySnapshot.docs.isNotEmpty) {
      try {
        lastFeedingType = feedingQuerySnapshot.docs[0]['type'];
        //Get the difference in time between now and when the last logged diaper was
        String diff = DateTime.now()
            .difference(
                DateTime.parse(feedingQuerySnapshot.docs[0]['date'].toString()))
            .inMinutes
            .toString();
        lastTimeFed = diff == '1' ? '$diff min' : '$diff mins';
      } catch (error) {
        //If there's an error, print it to the output
        debugPrint(error.toString());
      }
    }
    if (breastFeedingQuerySnapshot.docs.isNotEmpty) {
      try {
        lastBreastSide = breastFeedingQuerySnapshot.docs[0]['side'];
      } catch (error) {
        //If there's an error, print it to the output
        debugPrint(error.toString());
      }
    }
    if (bottleQuerySnapshot.docs.isNotEmpty) {
      try {
        lastBottleAmount = bottleQuerySnapshot.docs[0]['length'];
      } catch (error) {
        //If there's an error, print it to the output
        debugPrint(error.toString());
      }
    }
    setState(() {});
  }

  //Grab the data on page initialization
  @override
  void initState() {
    super.initState();
    getData();
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
      body: Center(
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(32),
            child: Text('Feeding',
                style: TextStyle(
                    fontSize: 36,
                    color: Theme.of(context).colorScheme.onBackground)),
          ),

          // Top card with data
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: FilledCard("last fed: $lastTimeFed",
                "type: $lastFeedingType", Icon(Icons.edit)),
          ),

          // Feeding options - breast feeding or bottle feeding
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: FeedingOptionCard(
                Icon(Icons.water_drop,
                    size: 40, color: Theme.of(context).colorScheme.onSecondary),
                "Breast feeding",
                "Last side: $lastBreastSide",
                () => context.go('/tracking/feeding/breastFeeding'),
                Theme.of(context)),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: FeedingOptionCard(
                Icon(Icons.local_drink,
                    size: 40, color: Theme.of(context).colorScheme.onSecondary),
                "Bottle feeding",
                "Last amount: $lastBottleAmount",
                () => context.go('/tracking/feeding/bottleFeeding'),
                Theme.of(context)),
          ),
        ]),
      ),
    );
  }
}

// Same as TrackingCard widget but different colors
class FeedingOptionCard extends StatelessWidget {
  const FeedingOptionCard(
      this.icon, this.name, this.extraInfo, this.pageFunc, this.theme,
      {super.key});
  final Icon icon;
  final String name;
  final String extraInfo;
  final void Function() pageFunc;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: theme.colorScheme.secondary,
      child: InkWell(
        splashColor: theme.colorScheme.secondary,
        onTap: pageFunc,
        child: SizedBox(
          width: 360,
          height: 80,
          child: Row(
            children: [
              Padding(padding: EdgeInsets.all(16), child: icon),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSecondary,
                      ),
                    ),
                    Text(
                      extraInfo,
                      style: TextStyle(
                        color: theme.colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: SizedBox()),
              Padding(
                padding: EdgeInsets.all(16),
                child: Align(
                    child: Icon(Icons.arrow_circle_right_outlined,
                        size: 30, color: theme.colorScheme.onSecondary)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
