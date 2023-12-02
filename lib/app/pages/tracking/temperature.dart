import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'dart:core';

class TemperaturePage extends StatefulWidget {
  const TemperaturePage({super.key});

  @override
  State<TemperaturePage> createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {
  String daysSinceTemp = "3";
  String lastTemp = "101.5";
  String buttonText = "Add Temp";
  final tempController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

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
      lastTemp = Text(tempController.text).data!;
      daysSinceTemp = Text(dateController.text).data!;
    });
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
            child: FilledCard("last temperature: $daysSinceTemp",
                "temperature: $lastTemp", Icon(Icons.device_thermostat)),
          ),

          // Add temp Card // TODO: round corners, default card open, turn into widget
          Padding(
            padding: const EdgeInsets.all(15),
            child: ExpansionTile(
              backgroundColor: Theme.of(context).colorScheme.surface,
              collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
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
                              color: Theme.of(context).colorScheme.onSurface)),
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
                        ),
                      ),
                    ),
                    Text('Time:',
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onSurface)),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: SizedBox(
                        width: 100.0,
                        child: TextField(
                          controller: timeController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '8:32',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(bottom: 20)),
                FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .secondary, // Background color
                    ),
                    onPressed: addClicked,
                    child: Text("$buttonText",
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onSecondary))),
              ],
            ),
          ),

          // History Card
          Padding(
            padding: EdgeInsets.all(15),
            child: ExpansionTile(
              backgroundColor: Theme.of(context).colorScheme.surface,
              collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
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
        ]),
      ),
    );
  }
}
