import 'package:babysteps/app/pages/home/home.dart';
import 'package:babysteps/app/widgets/loading_widget.dart';
import 'package:babysteps/app/widgets/social_only_widget.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class HomeLandingPage extends StatefulWidget {
  const HomeLandingPage({super.key});

  @override
  State<HomeLandingPage> createState() => _HomeLandingPageState();
}

class _HomeLandingPageState extends State<HomeLandingPage> {
  @override
  Widget build(BuildContext context) {
    // Navigation Bar
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Home'),
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
              return const LoadingWidget();
            } else {
            return !currentUser.value!.trackingView
                ? const SocialOnlyWidget()
                : SingleChildScrollView(
                    child: ValueListenableBuilder(
                      valueListenable: currentUser.value!.currentBaby,
                      builder: (context, value, child) {
                        return const HomePage();
                      },
                    ),
                  );
            }
          },
        )
    );
  }
}
