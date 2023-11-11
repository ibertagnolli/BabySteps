import 'package:flutter/material.dart';
import 'dart:core';

class BreastFeedingPage extends StatefulWidget {
  const BreastFeedingPage({super.key});

  @override
  State<BreastFeedingPage> createState() => _BreastFeedingPageState();
}

class _BreastFeedingPageState extends State<BreastFeedingPage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'Feeding',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Feeding'),
        ),
        body: Center(
          child: Column(children: <Widget>[
            //const FilledCard(),
          ]),
        ),
      ),
    );
  }
}

