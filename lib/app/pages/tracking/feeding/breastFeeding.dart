import 'package:babysteps/app/pages/tracking/feeding/add_previous_breastfeed.dart';
import 'package:babysteps/app/pages/tracking/feeding/breast_feeding_stopwatches.dart';
import 'package:babysteps/app/pages/tracking/feeding/feeding_database.dart';
import 'package:babysteps/app/widgets/loading_widget.dart';
import 'package:babysteps/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/pages/tracking/feeding/breastfeeding_stream.dart';
import 'package:babysteps/app/widgets/history_widgets.dart';
import 'dart:core';

class BreastFeedingPage extends StatefulWidget {
  const BreastFeedingPage({super.key});

  @override
  State<BreastFeedingPage> createState() => _BreastFeedingPageState();
}

class _BreastFeedingPageState extends State<BreastFeedingPage> {
  String? docId;
  int timeSoFarOnLeft = 0;
  int timeSoFarOnRight = 0;
  Map<String, dynamic>? sideMap;
  bool leftSideGoing = false;
  bool rightSideGoing = false;
  bool timerGoing = false;

//Get the data from the database
  Future getData() async {
    //Get the ongoing data
    QuerySnapshot ongoingBreastFeeding = await FeedingDatabaseMethods()
        .getLatestOngoingBreastFeedingEntry(
            currentUser.value!.currentBaby.value!.collectionId);
    //make sure we don't try to access an index that doesn't exist
    if (ongoingBreastFeeding.docs.isNotEmpty) {
      //get the document id so we can update it later
      docId = ongoingBreastFeeding.docs[0].id;
      Map<String, dynamic> left = ongoingBreastFeeding.docs[0]['side']['left'];
      Map<String, dynamic> right =
          ongoingBreastFeeding.docs[0]['side']['right'];

      timeSoFarOnLeft = left['duration'];
      timeSoFarOnRight = right['duration'];

      if (left['lastStart'] != null) {
        timeSoFarOnLeft += DateTime.now()
            .difference((left['lastStart'] as Timestamp).toDate())
            .inMilliseconds;
      }
      if (right['lastStart'] != null) {
        timeSoFarOnRight += DateTime.now()
            .difference((right['lastStart'] as Timestamp).toDate())
            .inMilliseconds;
      }

      sideMap = ongoingBreastFeeding.docs[0]['side'];

      leftSideGoing = left['active'];
      rightSideGoing = right['active'];
      timerGoing = ongoingBreastFeeding.docs[0]['active'];
    }

    return ongoingBreastFeeding;
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
          child: ValueListenableBuilder(
        valueListenable: currentUser,
        builder: (context, value, child) {
          if (value == null) {
            return const LoadingWidget();
          } else {
            return Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text('Breast Feeding',
                        style: TextStyle(
                            fontSize: 36,
                            color: Theme.of(context).colorScheme.onBackground)),
                  ),

                  // Top card with info
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: BreastFeedingStream(),
                  ),
                  FutureBuilder(
                    future: getData(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      List<Widget> children;
                      if (snapshot.hasData) {
                        children = <Widget>[
                          Column(
                            children: [
                              BreastFeedingStopwatches(
                                docId,
                                timeSoFarOnLeft,
                                timeSoFarOnRight,
                                sideMap,
                                leftSideGoing,
                                rightSideGoing,
                                timerGoing,
                              )
                            ],
                          )
                        ];
                      } else if (snapshot.hasError) {
                        children = errorMessage(snapshot.error.toString());
                      } else {
                        children = progressIndicator();
                      }
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: children,
                        ),
                      );
                    },
                  ),

                  // Add Previous Breastfeed
                  const Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 15, left: 15, right: 15),
                    child: AddPreviousBreastfeedCard(),
                  ),

                  // History Card - in widgets
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: HistoryDropdown("breastfeeding"),
                  ),
                ],
              ),
            );
          }
        },
      )),
    );
  }
}

List<Widget> progressIndicator() {
  return const [
    SizedBox(
      width: 60,
      height: 60,
      child: CircularProgressIndicator(),
    ),
    Padding(
      padding: EdgeInsets.only(top: 16),
      child: Text('Grabbing Data...'),
    )
  ];
}

List<Widget> errorMessage(String message) {
  return [
    const Icon(
      Icons.error_outline,
      color: Color.fromRGBO(244, 67, 54, 1),
      size: 60,
    ),
    Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text('Error: $message'),
    )
  ];
}
