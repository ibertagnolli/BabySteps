import 'package:babysteps/app/pages/tracking/weight/add_weight_card.dart';
import 'package:babysteps/app/pages/tracking/weight/weight_database.dart';
import 'package:babysteps/app/pages/tracking/weight/weight_stream.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'dart:core';

/// Holds the widgets for the Weight page.
class WeightPage extends StatefulWidget {
  const WeightPage({super.key});

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  String daysSinceWeight = '--';
  String lastWeightPounds = '--';
  String lastWeightOunces = '--';

  @override
  void initState() {
    super.initState();

    // Read real time updates to weight
    WeightDatabaseMethods().listenForWeightReads();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,

      // Temporary Nav Bar
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
          child: Column(
            children: [
              // Weight Title
              Padding(
                padding: const EdgeInsets.all(32),
                child: Text('Weight',
                    style: TextStyle(
                        fontSize: 36,
                        color: Theme.of(context).colorScheme.onBackground)),
              ),

              // FilledCard Quick Weight Info 
              // (WeightStream returns the card with real time reads)
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: SizedBox(
                  height: 180,
                  child: WeightStream(),
                ),
              ),

              // Add Weight Card
              const Padding(
                padding: EdgeInsets.all(15),
                child: AddWeightCard(),
              ),

              // History Card
              Padding(
                padding: const EdgeInsets.all(15),
                child: ExpansionTile(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  collapsedBackgroundColor:
                      Theme.of(context).colorScheme.surface,
                  title: Text('History',
                      style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold)),
                  children: <Widget>[
                    Text('TODO Add chart of baby\'s weight history here:',
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onSurface)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}