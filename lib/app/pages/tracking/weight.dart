import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


class WeightPage extends StatefulWidget {
  const WeightPage({super.key});

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  int daysSinceWeight = 3;
  double lastWeightPounds = 10.5;
  TextEditingController date = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weight',
      home: Scaffold(
        backgroundColor: const Color(0xffb3beb6),
        
        // Temporary Nav Bar
        appBar: AppBar(
          title: const Text('Tracking', style: TextStyle(fontSize: 36, color: Colors.black45)),
          backgroundColor: Color(0xFFFFFAF1),
        ),
        
        body: Center(
          child: ListView(children: <Widget>[
            
            // Weight Title
            const Padding(
              padding: EdgeInsets.all(32),
              child: Text('Weight', style: TextStyle(fontSize: 36, color: Color(0xFFFFFAF1))),
            ),
            
            // FilledCard Quick Weight Info
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: FilledCard(
                "Days since last weight: $daysSinceWeight",
                "weight: $lastWeightPounds", Icon(Icons.scale)
              ),
            ),
            
            // Add Weight Card // TODO: round corners 
            Padding(
              padding: const EdgeInsets.all(15),
              child: ExpansionTile(   // TODO does this need a PageExpansionKey? TODO: have open by default
                backgroundColor: const Color(0xFFFFFAF1),
                collapsedBackgroundColor: const Color(0xFFFFFAF1),
                title: const Text('Add Weight', style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold)),
                children: <Widget>[

                  // Padding around main contents of Weight Card
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(children: <Widget>[ // TODO make ListView instead? -> Will it need to scroll?

                      // First row: Weight inputs
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Row(children: <Widget> [
                          Text('Weight:', style: TextStyle(fontSize: 20, color: Colors.black)),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '13',
                                ),
                              ),
                            ),
                          ),
                          Text('lbs', style: TextStyle(fontSize: 20, color: Colors.black)),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '13',
                                ),
                              ),
                            ),
                          ),
                          Text('oz', style: TextStyle(fontSize: 20, color: Colors.black)),
                        ]),
                      ),

                      // Second row: Date input
                      TextField(
                        controller: date,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today_rounded),
                          labelText: "Select Date" // DateFormat('dd-MM-yyyy').format(DateTime.now()) // TODO: This is the idea for default date selection, doesn't work with const
                        ),
                        onTap: () async {
                          DateTime? pickeddate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(), 
                            firstDate: DateTime(2020), 
                            lastDate: DateTime(2101));

                          if (pickeddate != null) {
                            setState(() {
                              date.text = DateFormat('dd-MM-yyyy').format(pickeddate);
                            });
                          }
                        }
                      ),


                      // Third row: Submit
                    ], ),
                  ),
                ],
              ),
            ),

            // History Card
            const Padding(
              padding: EdgeInsets.all(15),
              child: ExpansionTile(
                backgroundColor: Color(0xFFFFFAF1),
                collapsedBackgroundColor: Color(0xFFFFFAF1),
                title: Text('History', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
                children: <Widget>[
                  ListTile(title: Text('This is tile 1')),
                ],
              ),
            ),



          ]),
        ),
      ),
    );
  }
}