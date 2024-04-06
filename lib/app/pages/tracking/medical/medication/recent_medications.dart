import 'package:babysteps/app/pages/tracking/medical/medication/medicine_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// The expandable card that displays Received Vaccines.
class RecentMedicationsCard extends StatefulWidget {
  const RecentMedicationsCard({super.key});

  @override
  State<StatefulWidget> createState() => _RecentMedicationsCardState();
}

class _RecentMedicationsCardState extends State<RecentMedicationsCard> { 
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        // Title
        backgroundColor: Theme.of(context).colorScheme.surface,
        collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Recent Medications',
            style: TextStyle(
                fontSize: 25,
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold)),
        initiallyExpanded: true,
        
        // Rows
        children: const <Widget> [
          MedicineStream(),
        ],
    );
  }
}
