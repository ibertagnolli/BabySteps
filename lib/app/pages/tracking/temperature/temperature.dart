import 'package:babysteps/app/pages/tracking/temperature/temperature_database.dart';
import 'package:babysteps/app/pages/tracking/temperature/add_temperature_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'dart:core';

import 'package:intl/intl.dart';

class TemperaturePage extends StatefulWidget {
  const TemperaturePage({super.key});

  @override
  State<TemperaturePage> createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {
  String daysSinceTemp = "--";
  String lastTemp = "--";
  String buttonText = "Add Temp";
  DateTime? lastDate;


 void tempAdded(String temp, DateTime dateInput) {
    setState(() {
      if ((lastDate == null ||
          lastDate != null && lastDate!.isBefore(dateInput))) {
        lastTemp = temp;
        String diff = DateTime.now().difference(dateInput).inDays.toString();
        daysSinceTemp = diff == '1' ? '$diff day' : '$diff days';
      }
    });
  }

  //Get the data from the database
  getData() async {
    QuerySnapshot querySnapshot =
        await TemperatureDatabaseMethods().getLatestTemperatureInfo();
    if (querySnapshot.docs.isNotEmpty) {
      try {
        lastTemp = querySnapshot.docs[0]['temp'];
        DateTime dt = (querySnapshot.docs[0]['date'] as Timestamp).toDate();
        lastDate = dt;
        //Get the difference in time between now and when the last logged diaper was
        String diff = DateTime.now().difference(dt).inDays.toString();
        daysSinceTemp = diff == '1' ? '$diff day' : '$diff days';
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
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Theme.of(context).colorScheme.onSurface,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Tracking'),
      ),

      body:  SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // Weight Title
              Padding(
                padding: EdgeInsets.all(32),
                child: Text('Temperature',
                    style: TextStyle(
                        fontSize: 36,
                        color: Theme.of(context).colorScheme.onBackground)),
              ),

              // FilledCard Quick Weight Info
              Padding(
                padding: EdgeInsets.only(bottom: 15),
                child:SizedBox(height: 200, child:  FilledCard("last temp: $daysSinceTemp",
                    "temperature: $lastTemp", Icon(Icons.device_thermostat)),),
              ),
// Add Weight Card
              Padding(
                padding: const EdgeInsets.all(15),
                child: AddTempCard(tempAdded: tempAdded),
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

