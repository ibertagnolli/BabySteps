import 'package:babysteps/app/pages/tracking/medical/vaccination/vaccine_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// The widget that adds a bottle.
class ReceivedVaccinationsCard extends StatefulWidget {
  const ReceivedVaccinationsCard({super.key});

  @override
  State<StatefulWidget> createState() => _ReceivedVaccinationsCardState();
}

/// Stores the mutable data that can change over the lifetime of the AddWeightCard.
class _ReceivedVaccinationsCardState extends State<ReceivedVaccinationsCard> { 
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        // Title
        backgroundColor: Theme.of(context).colorScheme.surface,
        collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Received Vaccines',
            style: TextStyle(
                fontSize: 25,
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold)),
        initiallyExpanded: true,
        
        // Rows
        children: const <Widget> [
          VaccineStream(),
        ],
    );
  }
}
