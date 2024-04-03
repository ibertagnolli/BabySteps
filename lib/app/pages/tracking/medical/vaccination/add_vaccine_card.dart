import 'package:babysteps/app/pages/tracking/medical/medical_database.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The expandable card that lets users add a vaccine.
class AddVaccineCard extends StatefulWidget {
  const AddVaccineCard({super.key});

  @override
  State<StatefulWidget> createState() => _AddVaccineCardState();
}

class _AddVaccineCardState extends State<AddVaccineCard> {
  // The global key uniquely identifies the Form widget and allows
  // validation of the form.
  final _formKey = GlobalKey<FormState>();

  TextEditingController vaccName = TextEditingController();
  TextEditingController reaction = TextEditingController();
  TextEditingController date = TextEditingController(
      text: DateFormat("MM/dd/yyyy").format(DateTime.now()));

  /// Saves a new vaccine entry in the Firestore database.
  saveNewVaccine() async {
    DateTime savedDate = DateFormat("MM/dd/yyyy").parse(date.text);
    // Add the time so Medical tracking card shows time of latest update
    DateTime savedDateWithTime = DateTime(savedDate.year, savedDate.month, savedDate.day, DateTime.now().hour, DateTime.now().minute);

    // Write weight data to database
    Map<String, dynamic> uploaddata = {
      'vaccine': vaccName.text,
      'reaction': reaction.text,
      'date': savedDateWithTime,
    };
    await MedicalDatabaseMethods().addVaccine(
        uploaddata, currentUser.value!.currentBaby.value!.collectionId);

    // Clear fields for next entry
    vaccName.clear();
    reaction.clear();
    date.clear();
    //add current date and time for autofill
    date.text = DateFormat.yMd().format(DateTime.now());
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    vaccName.dispose();
    reaction.dispose();
    date.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        // Title
        backgroundColor: Theme.of(context).colorScheme.surface,
        collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
        initiallyExpanded: true,
        title: Text('Add Vaccine',
            style: TextStyle(
                fontSize: 25,
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold)),
        // Input fields
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
            child: Form(
              key: _formKey,
              child: Column(children: <Widget>[

                // Date entry
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  child: TextFormField(
                    controller: date,
                    decoration: const InputDecoration(
                      labelText: "Date received",
                      icon: Icon(Icons.calendar_today_rounded),
                    ),
                    onTap: () async {
                      DateTime? pickeddate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now());

                      if (pickeddate != null) {
                        setState(() {
                          date.text =
                              DateFormat.yMd().format(pickeddate);
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a date';
                      }
                      return null;
                    },
                    // Don't show the keyboard
                    showCursor: true,
                    readOnly: true,
                  ),
                ),

                // Name of vaccine
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: TextFormField(
                    controller: vaccName,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      hintText: 'Name of vaccine'
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the vaccine name.';
                      }
                      return null;
                    },
                  )
                ),

                // Reactions
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: TextFormField(
                    controller: reaction,
                    maxLength: 300,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Baby\'s reactions to the vaccine'
                    ),
                  )
                ),

                // Third row: Submit button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        saveNewVaccine();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.tertiary),
                      foregroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.onTertiary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: const Text('Save Vaccine'),
                  ),
                ),
              ]),
            ),
          )
        ]);
  }
}
