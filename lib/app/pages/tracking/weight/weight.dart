import 'package:babysteps/app/pages/tracking/weight/add_weight_card.dart';
import 'package:babysteps/app/pages/tracking/weight/weight_database.dart';
import 'package:babysteps/app/pages/tracking/weight/weight_stream.dart';
import 'package:babysteps/app/pages/tracking/history_streams.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:flutter/material.dart';
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
             const Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child:SizedBox(
                  child: WeightStream(),
                ),
              ),

              // Add Weight Card
              const Padding(
                padding: EdgeInsets.all(15),
                child: AddWeightCard(),
              ),

              // History card - in widgets
              HistoryDropdown(WeightHistoryStream())
            ],
          ),
        ),
      ),
    );
  }
}