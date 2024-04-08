import 'package:babysteps/app/pages/tracking/tracking.dart';
import 'package:babysteps/app/widgets/loading_widget.dart';
import 'package:babysteps/app/widgets/social_only_widget.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrackingLandingPage extends StatefulWidget {
  const TrackingLandingPage({super.key});

  @override
  State<TrackingLandingPage> createState() => _TrackingLandingPageState();
}

class _TrackingLandingPageState extends State<TrackingLandingPage> {
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
        //TODO: remove when home is interesting
        actions: [
          IconButton(
              onPressed: () => context.go('/profile'),
              icon: const Icon(Icons.person))
        ],
      ),
      // Clickable TrackingCards to each tracking page
      body: ValueListenableBuilder(
        valueListenable: currentUser,
        builder: (context, value, child) {
          if (value == null) {
            return const LoadingWidget();
          } else {
            return currentUser.value!.trackingView
                ? SingleChildScrollView(
                    child: ValueListenableBuilder(
                      valueListenable: currentUser.value!.currentBaby,
                      builder: (context, value, child) {
                        return const TrackingPage();
                      },
                    ),
                  )
                : const SocialOnlyWidget();
          }
        },
      ),
    );
  }
}
