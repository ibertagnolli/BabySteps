import 'package:babysteps/app/pages/tracking/feeding/feeding_stream.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class FeedingPage extends StatefulWidget {
  const FeedingPage({super.key});

  @override
  State<FeedingPage> createState() => _FeedingPageState();
}

class _FeedingPageState extends State<FeedingPage> {
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
          child: Flex(direction: Axis.vertical, children: <Widget>[
            Padding(
              padding: EdgeInsets.all(32),
              child: Text('Feeding',
                  style: TextStyle(
                      fontSize: 36,
                      color: Theme.of(context).colorScheme.onBackground)),
            ),

            // Top card with data
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: SizedBox(
                child: FeedingStream(),
              ),
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
