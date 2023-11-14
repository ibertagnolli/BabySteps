import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'dart:core';

class TemperaturePage extends StatefulWidget {
  const TemperaturePage({super.key});

  @override
  State<TemperaturePage> createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {
  int daysSinceTemp = 3;
  String lastTemp = "101.5";
  String buttonText = "Add Temp";
final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

 void addClicked() {
    setState(() {
      // timerData = stopWatch.elapsedMilliseconds;
      // print(stopWatch.elapsedMilliseconds); // 0
      // stopWatch.start();
      //daysSinceTemp =  Text(myController.text).toString();
      lastTemp =  Text(myController.text).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature',
      home: Scaffold(
        backgroundColor: const Color(0xffb3beb6),

        // Temporary Nav Bar
        appBar: AppBar(
          title: const Text('Tracking',
              style: TextStyle(fontSize: 36, color: Colors.black45)),
          backgroundColor: Color(0xFFFFFAF1),
        ),

        body: Center(
          child: Column(children: <Widget>[
            // Weight Title
            const Padding(
              padding: EdgeInsets.all(32),
              child: Text('Temperature',
                  style: TextStyle(fontSize: 36, color: Color(0xFFFFFAF1))),
            ),

            // FilledCard Quick Weight Info
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: FilledCard("last temperature: $daysSinceTemp",
                  "temperature: $lastTemp", Icon(Icons.device_thermostat)),
            ),

            // Add temp Card // TODO: round corners, default card open, turn into widget
             Padding(
              padding:const EdgeInsets.all(15),
              child: ExpansionTile(
                backgroundColor: const Color(0xFFFFFAF1),
                collapsedBackgroundColor: const Color(0xFFFFFAF1),
                title:const Text('Add Temperature',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                children: <Widget>[
               const  Text('Temperature:',
                      style: TextStyle(fontSize: 20, color: Colors.black)),
               Padding(
                    padding:const EdgeInsets.all(20),
                    child: TextField(
                      controller: myController,
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
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text('Date:',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: SizedBox(
                          width: 100.0,
                          child: TextField(
                            controller: myController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: '10/27/23',
                            ),
                          ),
                        ),
                      ),
                      Text('Time:',
                          style: TextStyle(fontSize: 20, color: Colors.black)),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: SizedBox(
                          width: 100.0,
                          child: TextField(
                            controller: myController,
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
                  backgroundColor:
                       Color.fromARGB(255, 13, 60, 70), // Background color
                ),
                onPressed: addClicked,
                child: Text("$buttonText",
                    style:  TextStyle(
                        fontSize: 20, color: Color(0xFFFFFAF1)))),
            
                ],
              ),
            ),

            // History Card
            const Padding(
              padding: EdgeInsets.all(15),
              child: ExpansionTile(
                backgroundColor: Color(0xFFFFFAF1),
                collapsedBackgroundColor: Color(0xFFFFFAF1),
                title: Text('History',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                children: <Widget>[
                  ListTile(title: Text('No Recent Temeratures')),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
