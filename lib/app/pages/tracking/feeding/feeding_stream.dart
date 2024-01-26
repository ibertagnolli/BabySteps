import 'package:babysteps/app/pages/tracking/feeding/feeding_database.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:babysteps/app/widgets/feeding_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

// Streams for the feeding landing page - has a filled card, a breast feeding button, and a 
// bottle feeding button 

FirebaseFirestore db = FirebaseFirestore.instance;

/// The widget that reads realtime feeding updates for the FilledCard.
class FeedingStream extends StatefulWidget{
  @override
  _FeedingStreamState createState() => _FeedingStreamState();
}

class _FeedingStreamState extends State<FeedingStream> {
  final Stream<QuerySnapshot> _feedingStream = db.collection("Babies")
          .doc("IYyV2hqR7omIgeA4r7zQ")
          .collection("Feeding")
          .orderBy('date', descending: true)
          .limit(1)
          .snapshots();

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

        DateTime date = DateTime.parse(lastFeedDoc[0]['date'].toString());
        String diff = DateTime.now().difference(date).inMinutes.toString();
        String timeSinceFed = diff == '1' ? '$diff min' : '$diff mins';
        String lastType = lastFeedDoc[0]['type'];

        // Returns the FilledCard 

        return FilledCard("last fed: $timeSinceFed", "type: $lastType",
            const Icon(Icons.edit));
      },
    );
  }
}

/// The widget that reads realtime feeding updates for the breast feeding button.
class BreastFeedingStream extends StatefulWidget{
  @override
  _BreastFeedingStreamState createState() => _BreastFeedingStreamState();
}

class _BreastFeedingStreamState extends State<BreastFeedingStream> {
  final Stream<QuerySnapshot> _breastFeedingStream = db.collection('Babies')
        .doc(
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
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

        String lastBreastSide = lastFeedDoc[0]['side'];

        // Returns the breast feeding card/button 

        return FeedingOptionCard(
                Icon(Icons.water_drop,
                    size: 40, color: Theme.of(context).colorScheme.onSecondary),
                "Breast feeding",
                "Last side: $lastBreastSide",
                () => context.go('/tracking/feeding/breastFeeding'),
                Theme.of(context));
      },
    );
  }
}


/// The widget that reads realtime feeding updates for the bottle feeding button.
class BottleFeedingStream extends StatefulWidget{
  @override
  _BottleFeedingStreamState createState() => _BottleFeedingStreamState();
}

class _BottleFeedingStreamState extends State<BottleFeedingStream> {
  final Stream<QuerySnapshot> _bottleFeedingStream = db.collection('Babies')
        .doc(
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Feeding')
        .where('type', isEqualTo: 'Bottle')
        .where('active', isEqualTo: false)
        .orderBy('date', descending: true)
        .limit(1)
        .snapshots();

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

        String lastBottleType = lastFeedDoc[0]['bottleType'];

        // Returns the bottle feeding card/button 

        return FeedingOptionCard(
                Icon(Icons.local_drink,
                    size: 40, color: Theme.of(context).colorScheme.onSecondary),
                "Bottle feeding",
                "Last type: $lastBottleType",   // TODO: last bottle amount would be more helpful
                () => context.go('/tracking/feeding/bottleFeeding'),
                Theme.of(context));
      },
    );
  }
}