import 'package:babysteps/app/pages/tracking/feeding/feeding_database.dart';
import 'package:babysteps/app/widgets/feeding_widgets.dart';
import 'package:babysteps/main.dart';
import 'package:babysteps/time_since.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Streams for bottle feeding specific page

FirebaseFirestore db = FirebaseFirestore.instance;

/// The widget that reads realtime feeding updates for the bottle feeding info card.
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
        String timeSinceFed = 'Never';
        // String lastBottleType = 'None';
        String lastBottleAmount = 'None';

        if (lastFeedDoc.isNotEmpty) {
          DateTime date = lastFeedDoc[0]['date'].toDate();
          timeSinceFed = getTimeSince(date);
          // lastBottleType = lastFeedDoc[0]['bottleType'];
          lastBottleAmount = lastFeedDoc[0]['ounces'] + ' oz';
        }

        // Returns a bottle feeding info card

        return FeedingInfoCard(
            timeSinceFed,
            lastBottleAmount,
            "bottle amount",
            Icon(Icons.edit,
                size: 50, color: Theme.of(context).colorScheme.onSecondary),
            Theme.of(context));
      },
    );
  }
}
