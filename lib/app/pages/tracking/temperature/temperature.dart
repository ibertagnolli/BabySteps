import 'package:babysteps/app/pages/tracking/temperature/temperature_database.dart';
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
  final tempController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  //Upload data to the database with existing choices
  uploadData() async {
    DateTime currentDate = DateTime.now();
    DateTime dateInput = DateFormat("dd-MM-yyyy").parse(dateController.text);

    // Check that all fields have input
    if (tempController.text == "" || dateController.text == "") {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text('Please enter a temperature and a valid date.'));
          });

      throw Exception('Invalid weight input.');
    }
    // Check that date is today's date, or in the past
    else if (dateInput.isAfter(currentDate)) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text('Please enter a previous or current date.'));
          });

      throw Exception('Invalid date entry for weight input.');
    }
    // Write weight data to database
    else {
      Map<String, dynamic> uploaddata = {
        'temp': tempController.text,
        'date': dateInput,
        // 'time': timeController.text,
      };
      await TemperatureDatabaseMethods().addTemperature(uploaddata);
      addClicked();
    }
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
  void dispose() {
    // Clean up the controller when the widget is disposed.
    tempController.dispose();
    timeController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void addClicked() {
    setState(() {
      // timerData = stopWatch.elapsedMilliseconds;
      // print(stopWatch.elapsedMilliseconds); // 0
      // stopWatch.start();
      //daysSinceTemp =  Text(myController.text).toString();
      DateTime dateInput = DateFormat("dd-MM-yyyy").parse(dateController.text);
      if (lastDate == null ||
          (lastDate != null && lastDate!.isBefore(dateInput))) {
        String diff = DateTime.now().difference(dateInput).inDays.toString();
        daysSinceTemp = diff == '1' ? '$diff day' : '$diff days';
        lastTemp = Text(tempController.text).data!;
      }
      tempController.clear();
      dateController.clear();
      timeController.clear();
    });
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

      body: Center(
        child: ListView(children: <Widget>[
          Column(
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
                child: FilledCard("last temp: $daysSinceTemp",
                    "temperature: $lastTemp", Icon(Icons.device_thermostat)),
              ),

              // Add temp Card // TODO: round corners, default card open, turn into widget
              Padding(
                padding: const EdgeInsets.all(15),
                child: ExpansionTile(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  collapsedBackgroundColor:
                      Theme.of(context).colorScheme.surface,
                  title: Text('Add Temperature',
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold)),
                  children: <Widget>[
                    Text('Temperature:',
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onSurface)),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        controller: tempController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.device_thermostat),
                          border: OutlineInputBorder(),
                          hintText: '98.7',
                          labelText: 'Farenheight',
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text('Date:',
                              style: TextStyle(
                                  fontSize: 20,
                                  color:
                                      Theme.of(context).colorScheme.onSurface)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: SizedBox(
                            width: 100.0,
                            child: TextField(
                                controller: dateController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '10/27/23',
                                ),
                                onTap: () async {
                                  DateTime? pickeddate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2101));

                                  if (pickeddate != null) {
                                    setState(() {
                                      dateController.text =
                                          DateFormat('dd-MM-yyyy')
                                              .format(pickeddate);
                                    });
                                  }
                                }),
                          ),
                        ),
                        // Text('Time:',
                        //     style: TextStyle(
                        //         fontSize: 20,
                        //         color:
                        //             Theme.of(context).colorScheme.onSurface)),
                        // Padding(
                        //   padding: EdgeInsets.only(left: 10, right: 10),
                        //   child: SizedBox(
                        //     width: 100.0,
                        //     child: TextField(
                        //       controller: timeController,
                        //       decoration: InputDecoration(
                        //         border: OutlineInputBorder(),
                        //         hintText: '8:32',
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .secondary, // Background color
                        ),
                        onPressed: uploadData,
                        child: Text(
                          "$buttonText",
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.onSecondary),
                        ),
                      ),
                    ),
                  ],
                ),
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
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold)),
                  children: <Widget>[
                    ListTile(title: Text('No Recent Temeratures')),
                  ],
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
