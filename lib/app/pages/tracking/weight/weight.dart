import 'package:babysteps/app/pages/tracking/weight/add_weight_card.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Holds the widgets for the Weight page.
class WeightPage extends StatefulWidget {
  const WeightPage({super.key});

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  int daysSinceWeight = 3;
  double lastWeightPounds = 10.5;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weight',
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,

        // Temporary Nav Bar
        appBar: AppBar(
          title: Text('Tracking',
              style: TextStyle(fontSize: 36, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
            color: Theme.of(context).colorScheme.onSurface,
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),

        body: Center(
          child: ListView(children: <Widget>[
            // Weight Title
            Padding(
              padding: EdgeInsets.all(32),
              child: Text('Weight',
                  style: TextStyle(fontSize: 36, color: Theme.of(context).colorScheme.onBackground)),
            ),

            // FilledCard Quick Weight Info
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: FilledCard("last weight: $daysSinceWeight",
                  "weight: $lastWeightPounds", Icon(Icons.scale)),
            ),

            // Add Weight Card 
            Padding(
              padding: const EdgeInsets.all(15),
              child: AddWeightCard(),
            ),

            // History Card
            Padding(
              padding: EdgeInsets.all(15),
              child: ExpansionTile(
                backgroundColor: Theme.of(context).colorScheme.surface,
                collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
                title: Text('History',
                    style: TextStyle(
                        fontSize: 25,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold)),
                children: <Widget>[
                  Text('TODO Add chart of baby\'s weight history here:',
                      style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.onSurface)),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
