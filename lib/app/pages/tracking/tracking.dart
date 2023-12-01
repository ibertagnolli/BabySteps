import 'package:babysteps/app/pages/tracking/temperature.dart';
import 'package:babysteps/app/pages/tracking/weight/weight.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/pages/tracking/sleep.dart';
import 'package:babysteps/app/pages/tracking/diaper.dart';
import 'package:babysteps/app/pages/tracking/feeding/feeding.dart';
import 'package:babysteps/app/widgets/widgets.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<StatefulWidget> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  @override
  Widget build(BuildContext context) {
    return
        // Scaffold(
        //   appBar: AppBar(
        //     backgroundColor: const Color(0xffb3beb6),
        //     title: const Text('Tracking'),
        //   ),
        //   body:
        Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Text("Tracking Metrics",
                style: TextStyle(fontSize: 36, color: Theme.of(context).colorScheme.onBackground)),
          ),
          TrackingCard(
            const Icon(Icons.local_drink, size: 40),
            "Feeding",
            "15 mintues ago",
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const FeedingPage();
                  },
                ),
              );
            },
          ),
          TrackingCard(
            const Icon(Icons.crib, size: 40),
            "Sleep",
            "2 hours ago",
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SleepPage();
                  },
                ),
              );
            },
          ),
          TrackingCard(
            const Icon(Icons.baby_changing_station, size: 40),
            'Diaper Change',
            '3 hours ago',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DiaperPage()),
              );
            },
          ),
          TrackingCard(
            const Icon(Icons.scale, size: 40),
            "Weight",
            "2 months ago",
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const WeightPage();
                  },
                ),
              );
            },
          ),
          TrackingCard(
            const Icon(Icons.thermostat, size: 40),
            "Temperature",
            "3 weeks ago",
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const TemperaturePage();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
    // );
  }
}
