import 'package:babysteps/app/pages/user/profile.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileLoadingLanding extends StatefulWidget {
  const ProfileLoadingLanding({super.key});
  @override
  State<ProfileLoadingLanding> createState() => _ProfileLoadingLandingState();
}

class _ProfileLoadingLandingState extends State<ProfileLoadingLanding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Nav bar
        appBar: AppBar(
            title: const Text('Profile'),
            leading: BackButton(
                onPressed: () => context.go('/tracking'),
                // onPressed: () => context.go('/home'), //TODO: add back in when home is more interesting
                color: Theme.of(context).colorScheme.onSurface)),
        body: ValueListenableBuilder(
          valueListenable: currentUser,
          builder: (context, value, child) {
            if (value == null) {
              return const Text("Loading...");
            } else {
              return const ProfilePage();
            }
          },
        ));
  }
}
