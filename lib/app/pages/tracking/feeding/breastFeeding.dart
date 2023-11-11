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
            const FilledCard(),
          ]),
        ),
      ),
    );
  }
}

class FilledCard extends StatelessWidget {
  const FilledCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.primary,
        child: const SizedBox(
          width: 300,
          height: 100,
          child: Column(children: <Widget>[
            ListTile(
              title: Text('Time since last fed: 1:28'),
              // tileColor: ,
            ),
            Divider(height: 0),
            ListTile(
              title: Text('Last Type: Breast fed'),
              // tileColor: ,
            ),
            Divider(height: 0),
            ListTile(
              title: Text('Last side: right'),
              // tileColor: ,
            ),
            Divider(height: 0),
            ListTile(
              title: Text('Notes'),
              // tileColor: ,
            ),
          ]),
        ),
      ),
    );
  }
}