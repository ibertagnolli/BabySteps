import 'package:flutter/material.dart';
import 'dart:core';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Home'),
        leading: const Padding(
          padding: EdgeInsets.all(8),
          child: Image(
            image: AssetImage('assets/BabyStepsLogo.png'),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () => context.go('/profile'),
              icon: const Icon(Icons.person))
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
         SizedBox(
                width: 300,
                height: 300,
                child: Image.asset('assets/BabyStepsLogo.png',
                    fit: BoxFit.scaleDown)),
            Text(
              'Welcome to BabySteps',
              style: TextStyle(
                  fontSize: 30.0, color: Theme.of(context).colorScheme.surface),
            ),
            
          ],
        ),
      
      ),
      ),   
    );
  }
}
