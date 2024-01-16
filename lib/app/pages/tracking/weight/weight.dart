import 'package:babysteps/app/pages/tracking/weight/add_weight_card.dart';
import 'package:babysteps/app/pages/tracking/weight/weight_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'dart:core';

/// Holds the widgets for the Weight page.
class WeightPage extends StatefulWidget {
  const WeightPage({super.key});

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  String daysSinceWeight = '--';
  String lastWeightPounds = '--';
  String lastWeightOunces = '--';
  DateTime? lastDate;

  void weightAdded(String pounds, String ounces, DateTime dateInput) {
    setState(() {
      if ((lastDate == null ||
          lastDate != null && lastDate!.isBefore(dateInput))) {
        lastWeightPounds = pounds;
        lastWeightOunces = ounces;
        String diff = DateTime.now().difference(dateInput).inDays.toString();
        daysSinceWeight = diff == '1' ? '$diff day' : '$diff days';
      }
    });
  }

  //Get the data from the database
  getData() async {
    QuerySnapshot querySnapshot =
        await WeightDatabaseMethods().getLatestWeightInfo();
    if (querySnapshot.docs.isNotEmpty) {
      try {
        lastWeightPounds = querySnapshot.docs[0]['pounds'];
        lastWeightOunces = querySnapshot.docs[0]['ounces'];
        DateTime dt = (querySnapshot.docs[0]['date'] as Timestamp).toDate();
        lastDate = dt;
        //Get the difference in time between now and when the last logged diaper was
        String diff = DateTime.now().difference(dt).inDays.toString();
        daysSinceWeight = diff == '1' ? '$diff day' : '$diff days';
      } catch (error) {
        //If there's an error, print it to the output
        debugPrint(error.toString());
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,

      // Temporary Nav Bar
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Tracking'),
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // Weight Title
              Padding(
                padding: EdgeInsets.all(32),
                child: Text('Weight',
                    style: TextStyle(
                        fontSize: 36,
                        color: Theme.of(context).colorScheme.onBackground)),
              ),

              // FilledCard Quick Weight Info
              Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: SizedBox(
                  height: 200,
                  child: FilledCard(
                      "last weight: $daysSinceWeight",
                      "weight: $lastWeightPounds lbs $lastWeightOunces oz",
                      Icon(Icons.scale)),
                ),
              ),

              // Add Weight Card
              Padding(
                padding: const EdgeInsets.all(15),
                child: AddWeightCard(weightAdded: weightAdded),
              ),

              // History Card
              Padding(
                padding: EdgeInsets.all(15),
                child: ExpansionTile(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  collapsedBackgroundColor:
                      Theme.of(context).colorScheme.surface,
                  title: Text('History',
                      style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold)),
                  children: <Widget>[
                    Text('TODO Add chart of baby\'s weight history here:',
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onSurface)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
