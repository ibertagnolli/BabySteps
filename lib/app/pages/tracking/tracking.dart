import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<StatefulWidget> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Tracking'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Text("Tracking Metrics",
                  style: TextStyle(
                      fontSize: 36,
                      color: Theme.of(context).colorScheme.onBackground)),
            ),
            TrackingCard(const Icon(Icons.local_drink, size: 40), "Feeding",
                "15 mintues ago", () => context.go('/tracking/feeding')),
            TrackingCard(const Icon(Icons.crib, size: 40), "Sleep",
                "2 hours ago", () => context.go('/tracking/sleep')),
            TrackingCard(
                const Icon(Icons.baby_changing_station, size: 40),
                'Diaper Change',
                '3 hours ago',
                () => context.go('/tracking/diaper')),
            TrackingCard(const Icon(Icons.scale, size: 40), "Weight",
                "2 months ago", () => context.go('/tracking/weight')),
            TrackingCard(const Icon(Icons.thermostat, size: 40), "Temperature",
                "3 weeks ago", () => context.go('/tracking/temperature')),
          ],
        ),
      ),
    );
  }
}
