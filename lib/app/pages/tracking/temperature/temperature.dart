import 'package:babysteps/app/pages/tracking/temperature/add_temperature_card.dart';
import 'package:babysteps/app/pages/tracking/temperature/temperature_stream.dart';
import 'package:babysteps/app/widgets/history_widgets.dart';
import 'package:babysteps/app/widgets/loading_widget.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class TemperaturePage extends StatefulWidget {
  const TemperaturePage({super.key});

  @override
  State<TemperaturePage> createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {
  String daysSinceTemp = "--";
  String lastTemp = "--";

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

      body: SingleChildScrollView(
          child: ValueListenableBuilder(
        valueListenable: currentUser,
        builder: (context, value, child) {
          if (value == null) {
            return const LoadingWidget();
          } else {
            return Center(
              child: Column(
                children: [
                  // temperature Title
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text('Temperature',
                        style: TextStyle(
                            fontSize: 36,
                            color: Theme.of(context).colorScheme.onBackground)),
                  ),

                  // FilledCard Quick Temperature Info
                  // (TemperatureStream returns the card with real time reads)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: SizedBox(
                      child: TemperatureStream(),
                    ),
                  ),

                  // Add Temperature Card
                  const Padding(
                    padding: EdgeInsets.all(15),
                    child: AddTemperatureCard(),
                  ),

                  // History card - in widgets
                  HistoryDropdown("temperature")
                ],
              ),
            );
          }
        },
      )),
    );
  }
}
