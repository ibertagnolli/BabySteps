import 'package:babysteps/app/pages/tracking/temperature/temperature_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// The widget that adds a Temperature measurement.
class AddTemperatureCard extends StatefulWidget {
  const AddTemperatureCard({super.key});


  @override
  State<StatefulWidget> createState() => _AddTemperatureCardState();
}

/// Stores the mutable data that can change over the lifetime of the AddTemperatureCard.
class _AddTemperatureCardState extends State<AddTemperatureCard> {
  // The global key uniquely identifies the Form widget and allows 
  // validation of the form.
  final _formKey = GlobalKey<FormState>();

  TextEditingController temp = TextEditingController();
  TextEditingController date = TextEditingController(text: DateFormat("MM/dd/yyyy HH:mm").format(DateTime.now())); // TODO is 24hr time ok? this is hard-coded, so we would need a bool if user can customize it

  /// Saves a new Temperature entry in the Firestore database.
  saveNewTemperature() async {
    // Write Temperature data to database
    DateTime savedDate = DateFormat("MM/dd/yyyy hh:mm").parse(date.text);
    Map<String, dynamic> uploaddata = {
      'temperature': temp.text,
      'date': savedDate,
    };
    await TemperatureDatabaseMethods().addTemperature(uploaddata);

    
    // Clear fields for next entry
    temp.clear();
    date.clear();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    temp.dispose();
    date.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      backgroundColor: Theme.of(context).colorScheme.surface,
      collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
      title: Text('Add Temperature',
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

                // First row: Temperature input
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: <Widget>[

                      // Pounds input
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            controller: temp,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter temperature';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Second row: Date entry
                TextFormField(                  
                  controller: date,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today_rounded),
                  ),
                  onTap: () async {
                    // Don't show keyboard
                    FocusScope.of(context).requestFocus(new FocusNode());

                    DateTime? pickeddate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2101));

                      if (pickeddate != null) {
                        setState(() {
                          date.text =  DateFormat.yMd().add_jm().format(pickeddate);
                        });                      
                      }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a date';
                    }

                    // TODO check for dates out of range?
                    // NOTE: If user picks a date after current date, it reverts to the previously picked date.
                    // The entry field reflects this. No error checking, but doesn't let user input invalid data.

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
                        saveNewTemperature();
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
                    child: const Text('Save Temperature'),
                  ),
                ),
              ]
            ),
          ),
          )
      ]
    );
  }
}
