import 'package:flutter/material.dart';
import 'package:babysteps/app/pages/tracking/feeding/bottleFeeding.dart';
import 'package:babysteps/app/pages/tracking/feeding/breastFeeding.dart';
import 'dart:core';

class FeedingPage extends StatefulWidget {
  const FeedingPage({super.key});

  @override
  State<FeedingPage> createState() => _FeedingPageState();
}

class _FeedingPageState extends State<FeedingPage> {

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
            FilledButton(
              onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const BreastFeedingPage();
                  }));
                },
              child: Text("Breast feeding"),
            ),
            FilledButton(
              onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const BottleFeedingPage();
                  }));
                },
              child: Text("Bottle feeding"),
            ),
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