import 'package:babysteps/app/pages/tracking/feeding/feeding_database.dart';
import 'package:babysteps/app/widgets/landing_page_widgets.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:babysteps/app/widgets/feeding_widgets.dart';
import 'package:babysteps/main.dart';
import 'package:babysteps/time_since.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Streams for the medical landing page. Has cards for condition,
// vaccination, and medication.

/// The widget that reads realtime feeding updates for the FilledCard.
// class MedicalStream extends StatefulWidget {
//   const MedicalStream({super.key});

//   @override
//   State<StatefulWidget> createState() => _MedicalStreamState();
// }

// class _MedicalStreamState extends State<MedicalStream> {
//   final Stream<QuerySnapshot> _feedingStream = FeedingDatabaseMethods()
//       .getFeedingStream(currentUser.value!.currentBaby.value!.collectionId);

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _feedingStream,
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return const Text('Something went wrong');
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Text("Loading");
//         }

//         // An array of documents, but our query only returns an array of one document
//         var lastFeedDoc = snapshot.data!.docs;
//         String timeSinceFed = 'Never';
//         String lastType = '';
//         if (lastFeedDoc.isNotEmpty) {
//           DateTime date = lastFeedDoc[0]['date'].toDate();
//           timeSinceFed = getTimeSince(date);
//           lastType = lastFeedDoc[0]['type'];
//         }

//         // Returns the FilledCard

//         return FilledCard("last fed: $timeSinceFed", "type: $lastType",
//             const Icon(Icons.edit));
//       },
//     );
//   }
// }

/// The widget that reads realtime feeding updates for the breast feeding button.
class ConditionStream extends StatefulWidget {
  const ConditionStream({super.key});

  @override
  State<StatefulWidget> createState() => _ConditionStreamState();
}

class _ConditionStreamState extends State<ConditionStream> {
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

        // Returns the condition card/button

        return TrackingOptionCard(
            Icon(Icons.sick,
                size: 40, color: Theme.of(context).colorScheme.onPrimary),
            "Condition",
            "Last side: $lastBreastSide",
            () => context.go('/tracking/feeding/breastFeeding'),
            Theme.of(context));
      },
    );
  }
}

/// The widget that reads realtime feeding updates for the bottle feeding button.
class VaccinationStream extends StatefulWidget {
  const VaccinationStream({super.key});

  @override
  State<StatefulWidget> createState() => _VaccinationStreamState();
}

class _VaccinationStreamState extends State<VaccinationStream> {
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

        // Returns the vaccination card/button

        return TrackingOptionCard(
            Icon(Icons.vaccines,
                size: 40, color: Theme.of(context).colorScheme.onPrimary),
            "Vaccinations",
            "Last amount: $lastBottleAmount",
            () => context.go('/tracking/feeding/bottleFeeding'),
            Theme.of(context));
      },
    );
  }
}

/// The widget that reads realtime feeding updates for the bottle feeding button.
class MedicationStream extends StatefulWidget {
  const MedicationStream({super.key});

  @override
  State<StatefulWidget> createState() => _MedicationStreamState();
}

class _MedicationStreamState extends State<MedicationStream> {
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

        // Returns the medications card/button

        return TrackingOptionCard(
            Icon(Icons.medication_liquid,
                size: 40, color: Theme.of(context).colorScheme.onPrimary),
            "Medications",
            "Last amount: $lastBottleAmount",
            () => context.go('/tracking/feeding/bottleFeeding'),
            Theme.of(context));
      },
    );
  }
}
