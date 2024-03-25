import 'dart:async';
import 'package:babysteps/app/widgets/styles.dart';
import 'package:babysteps/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  LoadingWidgetState createState() => LoadingWidgetState();
}

class LoadingWidgetState extends State<LoadingWidget> {
  Stopwatch watch = Stopwatch();
  bool loadingState = true;

  updateLoadingState(Timer timer) {
    if (watch.isRunning) {
      if (mounted) {
        setState(() {
          loadingState = false;
          watch.stop();
          watch.reset();
          timer.cancel();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    watch.start();
    Timer.periodic(const Duration(seconds: 3), updateLoadingState);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: loadingState
            ? const Text(
                "Loading...",
                style: TextStyle(fontSize: 25),
              )
            : _ErrorLoadingWidget());
  }
}

class _ErrorLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "There may have been an error loading your information. Try logging out and logging back in or contact BabySteps for more help.",
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              currentUser.value = null;
              context.go('/login');
            },
            style: blueButton(context),
            child: const Text('Logout', style: TextStyle(fontSize: 26)),
          ),
        )
      ],
    );
  }
}
