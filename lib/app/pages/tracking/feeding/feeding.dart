import 'package:babysteps/app/pages/tracking/feeding/feeding_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:babysteps/app/pages/tracking/feeding/feeding_stream.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:babysteps/app/widgets/feeding_widgets.dart';
import 'dart:core';
import 'package:go_router/go_router.dart';
 
class FeedingPage extends StatefulWidget {
  const FeedingPage({super.key});

  @override
  State<FeedingPage> createState() => _FeedingPageState();
}

class _FeedingPageState extends State<FeedingPage> {

  @override
  void initState() {
    super.initState();
    FeedingDatabaseMethods().listenForFeedingReads();
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
     child: Center(
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
            child:
            SizedBox(
              height: 200, 
              child: FeedingStream(),
              ) ,
          ),

          // Feeding option buttons - breast feeding or bottle feeding
          // Both have basic info displayed on them, using real time reads
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: BreastFeedingStream(),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: BottleFeedingStream(),
          ),
        ]),
      ),
      ),
    );
  }
}


