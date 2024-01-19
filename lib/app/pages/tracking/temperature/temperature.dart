import 'package:babysteps/app/pages/tracking/temperature/temperature_database.dart';
import 'package:babysteps/app/pages/tracking/temperature/add_temperature_card.dart';
import 'package:babysteps/app/pages/tracking/temperature/temperature_stream.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'dart:core';

import 'package:intl/intl.dart';

class TemperaturePage extends StatefulWidget {
  const TemperaturePage({super.key});

  @override
  State<TemperaturePage> createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {
  String daysSinceTemp = "--";
  String lastTemp = "--";


  @override
  void initState() {
    super.initState();
   // getData();
    TemperatureDatabaseMethods().listenForTemperatureReads();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      // Temporary Nav Bar
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Theme.of(context).colorScheme.onSurface,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Tracking'),
      ),

      body:  SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // temperature Title
              Padding(
                padding: EdgeInsets.all(32),
                child: Text('Temperature',
                    style: TextStyle(
                        fontSize: 36,
                        color: Theme.of(context).colorScheme.onBackground)),
              ),

               // FilledCard Quick Temperature Info 
              // (TemperatureStream returns the card with real time reads)
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: SizedBox(
                  height: 180,
                  child: TemperatureStream(),
                ),
              ),

              // Add Temperature Card
              const Padding(
                padding: EdgeInsets.all(15),
                child: AddTemperatureCard(),
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
                    Text('TODO Add chart of baby\'s Temperature history here:',
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