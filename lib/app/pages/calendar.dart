import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:babysteps/app/widgets/checkList.dart';
import 'dart:core';


void main() => runApp(const CalendarPage());

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
 static const  String item1 = "3";
  static const String item2 = "101.5";
  static const String item3 = "do dishes";
  String buttonText = "Add Temp";
 

 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar',
      home: Scaffold(
        backgroundColor: const Color(0xffb3beb6),

        // Temporary Nav Bar
        appBar: AppBar(
          title: const Text('Calendar',
              style: TextStyle(fontSize: 36, color: Colors.black45)),
          backgroundColor: Color(0xFFFFFAF1),
        ),

        body: Center(
          child: ListView(children: <Widget>[
            // Weight Title
            const Padding(
              padding: EdgeInsets.all(32),
              child: Text('Calendar',
                  style: TextStyle(fontSize: 36, color: Color(0xFFFFFAF1))),
            ),

            // FilledCard Quick Weight Info
            // Padding(
            //   padding: EdgeInsets.only(bottom: 15),
            //   child: FilledCard("last temperature: $daysSinceTemp",
            //       "temperature: $lastTemp", Icon(Icons.device_thermostat)),
            // ),

            // Add temp Card // TODO: round corners, default card open, turn into widget
          //  const Padding(
          //     padding: const EdgeInsets.all(15),
          //     child: ExpansionTile(
          //       backgroundColor: const Color(0xFFFFFAF1),
          //       collapsedBackgroundColor: const Color(0xFFFFFAF1),
          //       title:  Text('TO DO:',
          //           style: TextStyle(
          //               fontSize: 20,
          //               color: Colors.black,
          //               fontWeight: FontWeight.bold)),
          //       children: <Widget>[
          //          Text('Get Groceries',
          //             style: TextStyle(fontSize: 20, color: Colors.black)),
          //         Padding(
          //           padding: EdgeInsets.all(20),
                  
          //         ),
          //         Column(
          //           children: <Widget>[
          //              Padding(
          //               padding: EdgeInsets.only(left: 20),
          //               //put check list here
          //                child: CheckboxListTileApp()
          //             ),
                      
          //           ],
          //         ),
          //         Padding(padding: EdgeInsets.only(bottom: 20)),
                  
          //       ],
          //     ),
          //   ),

  const Padding(
              padding: EdgeInsets.all(15),
              child: ExpansionTile(
                backgroundColor: Color(0xFFFFFAF1),
                collapsedBackgroundColor: Color(0xFFFFFAF1),
                title: Text('To Do',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                children: <Widget>[
                  CheckboxListTileExample(item1, item2, item3),
                  
                ],
              ),
            ),




            // Milestones Card
            const Padding(
              padding: EdgeInsets.all(15),
              child: ExpansionTile(
                backgroundColor: Color(0xFFFFFAF1),
                collapsedBackgroundColor: Color(0xFFFFFAF1),
                title: Text('Milestones',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                children: <Widget>[
                  ListTile(title: Text('No new milestones to be aware of')),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
