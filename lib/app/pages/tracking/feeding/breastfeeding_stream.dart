import 'package:babysteps/app/widgets/feeding_widgets.dart';
import 'package:babysteps/time_since.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Streams for breastfeeding specific page

FirebaseFirestore db = FirebaseFirestore.instance;

/// The widget that reads realtime feeding updates for the breastfeeding button.
class BreastFeedingStream extends StatefulWidget {
  const BreastFeedingStream({super.key});

  @override
  State<StatefulWidget> createState() => _BreastFeedingStreamState();
}

class _BreastFeedingStreamState extends State<BreastFeedingStream> {
  final Stream<QuerySnapshot> _breastFeedingStream = db
      .collection('Babies')
      .doc('IYyV2hqR7omIgeA4r7zQ')
      .collection('Feeding')
      .where('type', isEqualTo: 'BreastFeeding')
      .where('active', isEqualTo: false)
      .orderBy('date', descending: true)
      .limit(1)
      .snapshots();

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

        DateTime date = lastFeedDoc[0]['date'].toDate();
        String timeSinceFed = getTimeSince(date);
        String lastBreastSide = lastFeedDoc[0]['side'];

        // Returns a breastfeeding info card

        return FeedingInfoCard(
            timeSinceFed,
            lastBreastSide,
            "side",
            Icon(Icons.sync_alt,
                size: 50, color: Theme.of(context).colorScheme.onSecondary),
            Theme.of(context));
      },
    );
  }
}
