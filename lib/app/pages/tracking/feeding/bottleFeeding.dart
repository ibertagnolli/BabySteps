import 'package:flutter/material.dart';
import 'dart:core';

class BottleFeedingPage extends StatefulWidget {
  const BottleFeedingPage({super.key});

  @override
  State<BottleFeedingPage> createState() => _BottleFeedingPageState();
}

class _BottleFeedingPageState extends State<BottleFeedingPage> {

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

