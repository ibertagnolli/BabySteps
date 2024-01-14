import 'package:babysteps/app/pages/tracking/weight/weight_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// The widget that adds a weight measurement.
class AddWeightCard extends StatefulWidget {
  const AddWeightCard({super.key, required this.weightAdded});

  // Sends added weight data to the FilledCard -> this won't be necessary with realtime database updates
  final void Function(String pounds, String ounces, DateTime dateInput)
      weightAdded;

  @override
  State<StatefulWidget> createState() => _AddWeightCardState();
}

/// Stores the mutable data that can change over the lifetime of the AddWeightCard.
class _AddWeightCardState extends State<AddWeightCard> {
  // The global key uniquely identifies the Form widget and allows 
  // validation of the form.
  final _formKey = GlobalKey<FormState>();


  TextEditingController pounds = TextEditingController();
  TextEditingController ounces = TextEditingController();
  TextEditingController date = TextEditingController();

  /// Saves a new weight entry in the Firestore database.
  saveNewWeight() async {
    // DateTime dateInput =  DateFormat.yMd().add_jm().parse(date.text); //DateFormat("dd-MM-yyyy").parse(date.text); // TODO update times to include hours so the most recent entry for a given day is selected

    // Write weight data to database
    Map<String, dynamic> uploaddata = {
      'pounds': pounds.text,
      'ounces': ounces.text,
      'date': DateTime.now(), // TODO update to data from date TextEditingController
    };
    await WeightDatabaseMethods().addWeight(uploaddata);

    // Update the FilledCard
    widget.weightAdded(pounds.text, ounces.text, DateTime.now()); // TODO update to data from date TextEditingController
    pounds.clear();
    ounces.clear();
    date.clear();

    // TODO show something when the date is saved (check mark?)
    // TODO prevent user from inserting the data entry multiple times -> disable the Save button?
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    pounds.dispose();
    ounces.dispose();
    date.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      backgroundColor: Theme.of(context).colorScheme.surface,
      collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
      title: Text('Add Weight',
          style: TextStyle(
              fontSize: 25,
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold)),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[

                // First row: Weight inputs
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: <Widget>[

                      // Pounds input
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            controller: pounds,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter pounds';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Text('lbs',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface
                        )
                      ),

                      // Ounces input
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            controller: ounces,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter ounces';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Text('oz',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface
                        )
                      ),
                    ],
                  ),
                ),

                // Second row: Date input
                TextFormField(
                  controller: date,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today_rounded),
                  ),
                  // initialValue: DateFormat.yMd().add_jm().format(DateTime.now()),
                  validator: (value) {
                    // TODO check for dates out of range
                    if (value == null || value.isEmpty) {
                      return 'Please enter a date';
                    }
                    return null;
                  },
                ),

                // Third row: Submit button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        saveNewWeight();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.tertiary),
                      foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onTertiary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),

                    child: const Text('Save Weight'),
                  ),
                ),
              ]
            ),
          ),
          )
      ]
      





      

              // Second row: Date input
              // TextField(
              //     controller: date,
              //     // initialValue: DateFormat.yMd().add_jm().format(DateTime.now()),
              //     decoration: InputDecoration(
              //         icon: const Icon(Icons.calendar_today_rounded),
              //         labelText:
              //             DateFormat.yMd().add_jm().format(DateTime.now()),
              //             //"Select Date" // DateFormat('dd-MM-yyyy').format(DateTime.now()) // TODO: This is the idea for default date selection, doesn't work with const
              //     ),
              //     onTap: () async {
              //       DateTime? pickeddate = await showDatePicker(
              //           context: context,
              //           initialDate: DateTime.now(),
              //           firstDate: DateTime(2020),
              //           lastDate: DateTime(2101));

              //       if (pickeddate != null) {
              //         setState(() {
              //           date.text =  DateFormat.yMd().add_jm().format(pickeddate); // DateFormat('dd-MM-yyyy').format(pickeddate);
              //         });
              //       }
              //     }),

              // Third row: Submit button
              // Padding(
              //   padding: const EdgeInsets.only(top: 40),
              //   child: SizedBox(
              //     height: 75,
              //     width: 185,
              //     child: FilledButton.tonal(
              //       onPressed: saveNewWeight,
              //       style: ButtonStyle(
              //         backgroundColor: MaterialStateProperty.all(
              //             Theme.of(context).colorScheme.tertiary),
              //         foregroundColor: MaterialStateProperty.all(
              //             Theme.of(context).colorScheme.onTertiary),
              //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //           RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(20.0),
              //           ),
              //         ),
              //       ),
              //       child: const Text("Save", style: TextStyle(fontSize: 25)),
              //     ),
              //   ),
              // )
            // ],
          // ),
        // ),
      // ],
    );
  }
}
