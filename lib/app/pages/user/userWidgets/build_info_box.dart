import 'package:flutter/material.dart';

class BuildInfoBox extends StatelessWidget {
  const BuildInfoBox({super.key, required this.label, required this.fields});
  final String label;
  final List<Widget> fields;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, offset: Offset(2, 2), blurRadius: 10)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              //add the inputed info fields
              ...fields,
            ],
          ),
        ),
      ],
    );
  }
}