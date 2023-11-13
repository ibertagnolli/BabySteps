import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'dart:core';

class TemperaturePage extends StatefulWidget {
  const TemperaturePage({super.key});

  @override
  State<TemperaturePage> createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {
  int daysSinceTemp = 3;
  double lastTemp = 101.5;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature',
      home: Scaffold(
        backgroundColor: const Color(0xffb3beb6),

        // Temporary Nav Bar
        appBar: AppBar(
          title: const Text('Tracking',
              style: TextStyle(fontSize: 36, color: Colors.black45)),
          backgroundColor: Color(0xFFFFFAF1),
        ),

        body: Center(
          child: Column(children: <Widget>[
            // Weight Title
            const Padding(
              padding: EdgeInsets.all(32),
              child: Text('Temperature',
                  style: TextStyle(fontSize: 36, color: Color(0xFFFFFAF1))),
            ),

            // FilledCard Quick Weight Info
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: FilledCard("Days since last temperature: $daysSinceTemp",
                  "temperature: $lastTemp", Icon(Icons.device_thermostat)),
            ),

            // Add Weight Card // TODO: round corners
            Padding(
              padding: EdgeInsets.all(15),
              child: ExpansionTile(
                backgroundColor: Color(0xFFFFFAF1),
                collapsedBackgroundColor: Color(0xFFFFFAF1),
                title: const Text('Add Temperature',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                children: <Widget>[
                  const Text('Temperature'),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.device_thermostat),
                      hintText: 'Baby\'s Temperature',
                      labelText: 'Farenheight',
                    ),
                  ),
                  // TODO make widgets for the ListTiles
                  ListTile(title: Text('Date')),
                ],
              ),
            ),

            // History Card
            const Padding(
              padding: EdgeInsets.all(15),
              child: ExpansionTile(
                backgroundColor: Color(0xFFFFFAF1),
                collapsedBackgroundColor: Color(0xFFFFFAF1),
                title: Text('History',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
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
