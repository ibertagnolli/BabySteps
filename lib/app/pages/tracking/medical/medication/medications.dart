import 'package:babysteps/app/pages/tracking/medical/medication/add_medication_card.dart';
import 'package:babysteps/app/pages/tracking/medical/medication/recent_medications.dart';
import 'package:babysteps/app/widgets/loading_widget.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'dart:core';

/// The Medication Tracking page.
class MedicationsPage extends StatefulWidget {
  const MedicationsPage({super.key});

  @override
  State<MedicationsPage> createState() => _MedicationsPageState();
}

class _MedicationsPageState extends State<MedicationsPage> {
  @override
  Widget build(BuildContext context) {
    // Nav bar
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
      
      // Body
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
                    child: Text('Medications',
                        style: TextStyle(
                            fontSize: 36,
                            color: Theme.of(context).colorScheme.onBackground)),
                  ),

                  // Add vaccine card
                  const Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: AddMedicationCard(),
                  ),

                  // Received vaccines card
                  const Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 30, left: 15, right: 15),
                    child: RecentMedicationsCard(),
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
