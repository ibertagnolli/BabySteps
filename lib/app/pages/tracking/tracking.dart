import 'package:babysteps/app/pages/tracking/diaper/diaper_database.dart';
import 'package:babysteps/app/pages/tracking/feeding/feeding_database.dart';
import 'package:babysteps/app/pages/tracking/tracking_widgets.dart';
import 'package:babysteps/app/pages/tracking/sleep/sleep_database.dart';
import 'package:babysteps/app/pages/tracking/temperature/temperature_database.dart';
import 'package:babysteps/app/pages/tracking/weight/weight_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<StatefulWidget> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  final Stream<QuerySnapshot> _feedingStream = FeedingDatabaseMethods().getFeedingStream();
  final Stream<QuerySnapshot> _sleepStream = SleepDatabaseMethods().getStream();
  final Stream<QuerySnapshot> _diaperStream = DiaperDatabaseMethods().getStream();
  final Stream<QuerySnapshot> _weightStream = WeightDatabaseMethods().getStream();
  final Stream<QuerySnapshot> _tempStream = TemperatureDatabaseMethods().getStream();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Navigation Bar
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Tracking'),
        leading: const Padding(
          padding: EdgeInsets.all(8),
          child: Image(
            image: AssetImage('assets/BabyStepsLogo.png'),
          ),
        ),
      ),
      // Clickable TrackingCards to each tracking page
      body: SingleChildScrollView(
        child: Center(
          child: 
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Column(
            children: [
              TrackingStream(const Icon(Icons.local_drink, size: 40),
                  "Feeding", '/tracking/feeding',
                  stream: _feedingStream),
              TrackingStream(
                  const Icon(Icons.crib, size: 40), "Sleep", '/tracking/sleep',
                  stream: _sleepStream),
              TrackingStream(const Icon(Icons.baby_changing_station, size: 40),
                  'Diaper Change', '/tracking/diaper',
                  stream: _diaperStream),
              TrackingStream(
                const Icon(Icons.scale, size: 40),
                "Weight", '/tracking/weight',
                stream: _weightStream,
              ),
              TrackingStream(
                const Icon(Icons.thermostat, size: 40),
                "Temperature", '/tracking/temperature',
                stream: _tempStream,
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}
