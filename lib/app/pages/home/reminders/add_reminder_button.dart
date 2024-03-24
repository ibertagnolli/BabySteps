import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:babysteps/app/pages/home/reminders/reminders_database.dart';
import 'dart:core';

// The widget that adds a new reminder.
class AddReminderButton extends StatefulWidget {
  AddReminderButton({super.key});

  @override
  State<StatefulWidget> createState() => _AddReminderButtonState();
}

/// Stores the mutable data that can change over the lifetime of the AddReminderButton.
class _AddReminderButtonState extends State<AddReminderButton> {
  // The global key uniquely identifies the Form widget and allows
  // validation of the form.
  final _formKey = GlobalKey<FormState>();
  int reminderType = 1;

  // Store user input for database upload
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TimeOfDay reminderTime = TimeOfDay.now();

  setReminderType(int selectedType)  {
    setState(() {
      reminderType = selectedType;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  // Gets the user's selected reminder time.
  void _selectTime() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (selectedTime != null) {
      setState(() {
        reminderTime = selectedTime;
        timeController.text = selectedTime.format(context);
      });
    }
  }

  /// Saves a new reminder entry in the Firestore database.
  saveNewReminder() async {
    DateTime reminderDate = DateFormat("MM/dd/yyyy").parse(dateController.text);
    DateTime reminderDT = DateTime(reminderDate.year, reminderDate.month, reminderDate.day,
        reminderTime.hour, reminderTime.minute);

    // Write reminder data to database
    Map<String, dynamic> uploaddata = {
      'name': nameController.text,
      'dateTime': reminderDT,
      'completed': false,
    };
    await RemindersDatabaseMethods()
        .addReminder(uploaddata, currentUser.value!.userDoc);

    // Clear fields for next entry (not date)
    nameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Populate the controllers
    dateController.text = DateFormat.yMd().format(DateTime.now());
    timeController.text = TimeOfDay.now().format(context);

    return SizedBox(
      // Add Reminder Button
      width: 170.0,
      height: 30.0,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.tertiary),
          foregroundColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.onTertiary),
          shape:
              MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        child: const Text('Add Reminder'),

        // Dialog with reminder entry
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    scrollable: true,
                    title: const Text("New Reminder"),
                    content: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[

                              // Reminder Name
                              TextFormField(
                                controller: nameController,
                                maxLength: 30,
                                decoration: const InputDecoration(
                                  labelText: "Remind me about",
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the reminder title';
                                  }
                                  return null;
                                },
                              ),

                              // Reminder Type
                              RadioButtons((int selectedType) {
                                setState(() { reminderType = selectedType; });
                                print(selectedType);
                              },),

                              // Reminder Date
                              TextFormField(
                                controller: dateController,
                                decoration: const InputDecoration(
                                  labelText: "Date",
                                ),
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2050));

                                  if (pickedDate != null) {
                                    dateController.text = DateFormat.yMd()
                                        .add_jm()
                                        .format(pickedDate);
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

                              // Reminder Time
                              TextFormField(
                                controller: timeController,
                                decoration: const InputDecoration(
                                  labelText: "Time",
                                ),
                                onTap: _selectTime,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the reminder time';
                                  }
                                  return null;
                                },
                                // Don't show the keyboard
                                showCursor: true,
                                readOnly: true,
                              ),

                              // Submit button
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        saveNewReminder();
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text("Submit")),
                              )
                            ],
                          )),
                    ));
              });
        },
      ),
    );
  }
}



class RadioButtons extends StatefulWidget {
  const RadioButtons(this.setTypeFunction, {super.key});

  final Function(int val) setTypeFunction;

  @override
  State<RadioButtons> createState() => _RadioButtonsState();
}

class _RadioButtonsState extends State<RadioButtons> {
  int selectedOption = 1; 

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('in'),
          leading: Radio<int>(
            value: 1,
            groupValue: selectedOption,
            onChanged: (value) {
              setState(() {
                selectedOption = value!;
              });
              widget.setTypeFunction(value!);
            },
          ),
        ),
        ListTile(
          title: const Text('at'),
          leading: Radio<int>(
            value: 2,
            groupValue: selectedOption,
            onChanged: (value) {
              setState(() {
                selectedOption = value!;
              });
              widget.setTypeFunction(value!);
            },
          ),
        ),
        ListTile(
          title: const Text('every'),
          leading: Radio<int>(
            value: 3,
            groupValue: selectedOption,
            onChanged: (value) {
              setState(() {
                selectedOption = value!;
              });
              widget.setTypeFunction(value!);
            },
          ),
        ),
      ],
    );
  }
}
