import 'package:flutter/material.dart';
import 'dart:core';

import 'package:go_router/go_router.dart';

class LoginLandingPage extends StatefulWidget {
  const LoginLandingPage({super.key});

  @override
  State<LoginLandingPage> createState() => _LoginLandingPageState();
}

class _LoginLandingPageState extends State<LoginLandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: 
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset('assets/BabyStepsLogo.png',
                      fit: BoxFit.scaleDown)),
              Text(
                'Welcome to BabySteps!',
                style: TextStyle(
                    fontSize: 30.0,
                    color: Theme.of(context).colorScheme.surface),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                    onPressed: () => context.go('/login/loginPage'),
                    style: FilledButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primary),
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Theme.of(context).colorScheme.surface),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: FilledButton(
                    onPressed: () => context.go('/login/signup'),
                    style: FilledButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primary),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
