import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'dart:core';

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
        backgroundColor: const Color(0xffb3beb6),
        
        // Temporary Nav Bar
        appBar: AppBar(
          title: const Text('Tracking', style: TextStyle(fontSize: 36, color: Colors.black45)),
          backgroundColor: Color(0xFFFFFAF1),
        ),
        
        body: Center(
          child: Column(children: <Widget>[
            
            // Weight Title
            const Padding(
              padding: EdgeInsets.all(32),
              child: Text('Weight', style: TextStyle(fontSize: 36, color: Color(0xFFFFFAF1))),
            ),
            
            // FilledCard Quick Weight Info
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: FilledCard(
                "Days since last weight: $daysSinceWeight",
                "weight: $lastWeightPounds", Icon(Icons.scale)
              ),
            ),
            
            // Add Weight Card // TODO: round corners
            const Padding(
              padding: EdgeInsets.all(15),
              child: ExpansionTile(
                backgroundColor: Color(0xFFFFFAF1),
                collapsedBackgroundColor: Color(0xFFFFFAF1),
                title: Text('Add Weight', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
                children: <Widget>[
                  ListTile(title: Text('This is tile 1')), // TODO make widgets for the ListTiles
                  ListTile(title: Text('This is tile 2')),
                ],
              ),
            ),

            // History Card
            const Padding(
              padding: EdgeInsets.all(15),
              child: ExpansionTile(
                backgroundColor: Color(0xFFFFFAF1),
                collapsedBackgroundColor: Color(0xFFFFFAF1),
                title: Text('History', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
                children: <Widget>[
                  ListTile(title: Text('This is tile 1')),
                ],
              ),
            ),



          ]),
        ),
      ),
    );
  }
}