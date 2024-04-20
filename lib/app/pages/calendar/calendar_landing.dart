import 'package:babysteps/app/pages/calendar/calendar.dart';
import 'package:babysteps/app/widgets/loading_widget.dart';
import 'package:babysteps/app/widgets/social_only_widget.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'dart:core';

import 'package:go_router/go_router.dart';

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
          actions: [
            IconButton(
                onPressed: () => context.goNamed('/profile',
                    queryParameters: {'lastPage': 'calendar'}),
                icon: const Icon(Icons.person))
          ],
        ),

        // Widgets
        body: ValueListenableBuilder(
          valueListenable: currentUser,
          builder: (context, value, child) {
            if (value == null) {
              return const LoadingWidget();
            } else {
              return currentUser.value!.trackingView
                  ? ValueListenableBuilder(
                      valueListenable: currentUser.value!.currentBaby,
                      builder: (context, value, child) => const CalendarPage(),
                    )
                  : const SocialOnlyWidget();
            }
          },
        ));
  }
}
