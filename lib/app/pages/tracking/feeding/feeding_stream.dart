import 'package:babysteps/app/pages/tracking/feeding/feeding_database.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:babysteps/app/widgets/feeding_widgets.dart';
import 'package:babysteps/main.dart';
import 'package:babysteps/time_since.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Streams for the feeding landing page - has a filled card, a breast feeding button, and a
// bottle feeding button

/// The widget that reads realtime feeding updates for the FilledCard.
class FeedingStream extends StatefulWidget {
  const FeedingStream({super.key});

  @override
  State<StatefulWidget> createState() => _FeedingStreamState();
}

class _FeedingStreamState extends State<FeedingStream> {
  final Stream<QuerySnapshot> _feedingStream = FeedingDatabaseMethods()
      .getFeedingStream(currentUser.value!.currentBaby.value!.collectionId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _feedingStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // An array of documents, but our query only returns an array of one document
        var lastFeedDoc = snapshot.data!.docs;
        String timeSinceFed = 'Never';
        String lastType = '';
        if (lastFeedDoc.isNotEmpty) {
          DateTime date = lastFeedDoc[0]['date'].toDate();
          timeSinceFed = getTimeSince(date);
          lastType = lastFeedDoc[0]['type'];
        }

        // Returns the FilledCard

        return FilledCard("last fed: $timeSinceFed", "type: $lastType",
            const Icon(Icons.edit));
      },
    );
  }
}

/// The widget that reads realtime feeding updates for the breast feeding button.
class BreastFeedingStream extends StatefulWidget {
  const BreastFeedingStream({super.key});

  @override
  State<StatefulWidget> createState() => _BreastFeedingStreamState();
}

class _BreastFeedingStreamState extends State<BreastFeedingStream> {
  final Stream<QuerySnapshot> _breastFeedingStream = FeedingDatabaseMethods()
      .getBreastfeedingStream(
          currentUser.value!.currentBaby.value!.collectionId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _breastFeedingStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // An array of documents, but our query only returns an array of one document
        var lastFeedDoc = snapshot.data!.docs;
        String lastBreastSide = 'None';

        if (lastFeedDoc.isNotEmpty) {
          lastBreastSide = lastFeedDoc[0]['side']['latest'];
        }

        // Returns the breast feeding card/button

        return FeedingOptionCard(
            Icon(Icons.water_drop,
                size: 40, color: Theme.of(context).colorScheme.onPrimary),
            "Breast feeding",
            "Last side: $lastBreastSide",
            () => context.go('/tracking/feeding/breastFeeding'),
            Theme.of(context));
      },
    );
  }
}

/// The widget that reads realtime feeding updates for the bottle feeding button.
class BottleFeedingStream extends StatefulWidget {
  const BottleFeedingStream({super.key});

  @override
  State<StatefulWidget> createState() => _BottleFeedingStreamState();
}

class _BottleFeedingStreamState extends State<BottleFeedingStream> {
  final Stream<QuerySnapshot> _bottleFeedingStream = FeedingDatabaseMethods()
      .getBottleFeedingStream(
          currentUser.value!.currentBaby.value!.collectionId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _bottleFeedingStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // An array of documents, but our query only returns an array of one document
        var lastFeedDoc = snapshot.data!.docs;

        String lastBottleAmount = 'None';

        if (lastFeedDoc.isNotEmpty) {
          lastBottleAmount = lastFeedDoc[0]['ounces'] + ' oz';
        }

        // Returns the bottle feeding card/button

        return FeedingOptionCard(
            Icon(Icons.local_drink,
                size: 40, color: Theme.of(context).colorScheme.onPrimary),
            "Bottle feeding",
            "Last amount: $lastBottleAmount",
            () => context.go('/tracking/feeding/bottleFeeding'),
            Theme.of(context));
      },
    );
  }
}
