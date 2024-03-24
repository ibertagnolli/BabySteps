import 'package:babysteps/app/pages/calendar/calendar.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class CalendarLandingPage extends StatefulWidget {
  const CalendarLandingPage({super.key});

  @override
  State<CalendarLandingPage> createState() => _CalendarLandingPageState();
}

class _CalendarLandingPageState extends State<CalendarLandingPage> {
  @override
  Widget build(BuildContext context) {
    // Navigation Bar
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Calendar'),
          leading: const Padding(
            padding: EdgeInsets.all(8),
            child: Image(
              image: AssetImage('assets/BabyStepsLogo.png'),
            ),
          ),
        ),

        // Widgets
        body: ValueListenableBuilder(
          valueListenable: currentUser,
          builder: (context, value, child) {
            if (value == null) {
              return const Text("Loading...");
            } else {
              return ValueListenableBuilder(
                valueListenable: currentUser.value!.currentBaby,
                builder: (context, value, child) => const CalendarPage(),
              );
            }
          },
        ));
  }
}