import 'package:babysteps/app/pages/tracking/feeding/feeding_database.dart';
import 'package:babysteps/app/pages/tracking/medical/medical_database.dart';
import 'package:babysteps/app/widgets/landing_page_widgets.dart';
import 'package:babysteps/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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

/// Reads realtime updates for the Vaccination TrackingOptionCard.
/// This card directs to the Vaccination tracking page.
class VaccinationStream extends StatefulWidget {
  const VaccinationStream({super.key});

  @override
  State<StatefulWidget> createState() => _VaccinationStreamState();
}

class _VaccinationStreamState extends State<VaccinationStream> {
  final Stream<QuerySnapshot> _vaccineUpdateStream = MedicalDatabaseMethods()
      .getLatestVaccineUpdate(currentUser.value!.currentBaby.value!.collectionId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _vaccineUpdateStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // An array of documents, but our query only returns an array of one document
        var lastVaccDoc = snapshot.data!.docs;

        String lastUpdateOn = 'Never';
        if (lastVaccDoc.isNotEmpty) {
          lastUpdateOn = DateFormat('MM/dd/yyyy').format(lastVaccDoc[0]['date'].toDate());
        }

        // Returns the vaccination card/button
        return TrackingOptionCard(
            Icon(Icons.vaccines,
                size: 40, color: Theme.of(context).colorScheme.onPrimary),
            "Vaccinations",
            "Last entry: $lastUpdateOn",
            () => context.go('/tracking/medical/vaccinations'),
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
