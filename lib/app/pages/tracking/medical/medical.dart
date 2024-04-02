import 'package:babysteps/app/pages/tracking/feeding/feeding_stream.dart';
import 'package:babysteps/app/pages/tracking/medical/condition_stream.dart';
import 'package:babysteps/app/pages/tracking/medical/medical_stream.dart';
import 'package:babysteps/app/pages/tracking/medical/medication_stream.dart';
import 'package:babysteps/app/pages/tracking/medical/vaccination_stream.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class MedicalPage extends StatefulWidget {
  const MedicalPage({super.key});

  @override
  State<MedicalPage> createState() => _MedicalPageState();
}

class _MedicalPageState extends State<MedicalPage> {
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
      
      // Widgets
      body: SingleChildScrollView(
        child: Center(
          child: Flex(direction: Axis.vertical, children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text('Medical',
                  style: TextStyle(
                      fontSize: 36,
                      color: Theme.of(context).colorScheme.onBackground)),
            ),

            // Top card with data
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: SizedBox(
                child: MedicalStream(),
              ),
            ),

            // Feeding option buttons - breast feeding or bottle feeding
            // Both have basic info displayed on them, using real time reads
            const Padding(
              padding: EdgeInsets.only(bottom: 16, left: 15, right: 15),
              child: ConditionStream(),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16, left: 15, right: 15),
              child: VaccinationStream(),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16, left: 15, right: 15),
              child: MedicationStream(),
            ),
          ]),
        ),
      ),
    );
  }
}
