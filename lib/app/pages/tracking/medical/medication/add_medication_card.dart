import 'package:babysteps/app/pages/tracking/medical/medical_database.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The expandable card that lets users add a medication.
class AddMedicationCard extends StatefulWidget {
  const AddMedicationCard({super.key});

  @override
  State<StatefulWidget> createState() => _AddMedicationCardState();
}

class _AddMedicationCardState extends State<AddMedicationCard> {
  // The global key uniquely identifies the Form widget and allows
  // validation of the form.
  final _formKey = GlobalKey<FormState>();

  TextEditingController medName = TextEditingController();
  TextEditingController reaction = TextEditingController();
  TextEditingController date = TextEditingController(
      text: DateFormat("MM/dd/yyyy HH:mm").format(DateTime.now()));

  /// Saves a new medication entry in the Firestore database.
  saveNewMedication() async {
    DateTime savedDate = DateFormat("MM/dd/yyyy HH:mm").parse(date.text);
    
    // Write weight data to database
    Map<String, dynamic> uploaddata = {
      'medication': medName.text,
      'reaction': reaction.text,
      'date': savedDate,
    };
    await MedicalDatabaseMethods().addMedication(
        uploaddata, currentUser.value!.currentBaby.value!.collectionId);

    // Clear fields for next entry
    medName.clear();
    reaction.clear();
    date.clear();
    //add current date and time for autofill
    date.text = DateFormat.yMd().add_jm().format(DateTime.now());
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    medName.dispose();
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
        title: Text('Add Medication',
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
                      
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context, 
                        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                      );

                      if (pickeddate != null && pickedTime != null) {
                        DateTime pickedDateAndTime = DateTime(
                          pickeddate.year, pickeddate.month, pickeddate.day, 
                          pickedTime.hour, pickedTime.minute,
                        );
                        setState(() {
                          date.text =
                              DateFormat.yMd().add_jm().format(pickedDateAndTime);
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

                // Name of medication
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: TextFormField(
                    controller: medName,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      hintText: 'Name of medication'
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the medication name.';
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
                      hintText: 'Baby\'s reactions to the medication'
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
                        saveNewMedication();
                        FocusManager.instance.primaryFocus?.unfocus();
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
                    child: const Text('Save Medication'),
                  ),
                ),
              ]),
            ),
          )
        ]);
  }
}
