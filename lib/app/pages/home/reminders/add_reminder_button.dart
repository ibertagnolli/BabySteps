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

  // Store user input for database upload
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController howManyController = TextEditingController();
  TimeOfDay reminderTime = TimeOfDay.now();
  int reminderType = 1;
  String timeUnit = "minutes";

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    dateController.dispose();
    timeController.dispose();
    howManyController.dispose();
    super.dispose();
  }

  // Gets the user's selected reminder time.
  void _selectTime() async {
    final TimeOfDay? selectedTime = await showTimePicker( // TODO: fix setState during build
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

  _setReminderType(int selectedType)  {
    
    WidgetsBinding.instance.addPostFrameCallback((_){
      print(selectedType);
      setState(() {
        reminderType = selectedType;
      });
    });
  }

  _setTimeUnit(String selectedUnit)  {
    
    WidgetsBinding.instance.addPostFrameCallback((_){
      print(selectedUnit);
      setState(() {
        timeUnit = selectedUnit;
      });
    });
  }

  /// Saves a new reminder entry in the Firestore database.
  saveNewReminder() async {
    
    DateTime reminderDT; 
    DateTime now = DateTime.now();

    // remind "in" a certain amount of time
    if(reminderType == 1) {
      int timeInterval = int.parse(howManyController.text);
      if (timeUnit == "minutes") {
        int minutes = now.minute + timeInterval;
        reminderDT = DateTime(now.year, now.month, now.day,
        now.hour, minutes);
      }
      else if (timeUnit == "hours") {
        int hours = now.hour + timeInterval;
        reminderDT = DateTime(now.year, now.month, now.day,
        hours, now.minute);
      }
      else { // days
        int days = now.day + timeInterval;
        reminderDT = DateTime(now.year, now.month, days,
        now.hour, now.minute);
      }
    }
    // remind "at" certain time
    else {
      DateTime reminderDate = DateFormat("MM/dd/yyyy").parse(dateController.text);
      reminderDT = DateTime(reminderDate.year, reminderDate.month, reminderDate.day,
        reminderTime.hour, reminderTime.minute);
    }
    // Write reminder data to database
    Map<String, dynamic> uploaddata = {
      'remindAbout': nameController.text,
      'dateTime': reminderDT,
      'reminderType': (reminderType == 1) ? "in" : "at",
    };
    await RemindersDatabaseMethods()
        .addReminder(uploaddata, currentUser.value!.userDoc);

    // Clear fields for next entry (not date)
    nameController.clear();
    howManyController.clear();
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

                              NewReminderForm(nameController, howManyController, dateController, timeController, _selectTime, _setReminderType, _setTimeUnit),

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


class DateAndTime extends StatelessWidget {
  const DateAndTime(
      this.dateController, this.timeController, this._selectTime, {super.key});
  final TextEditingController dateController;
  final TextEditingController timeController;
  final Function() _selectTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
                return 'Please enter reminder time';
              }
              return null;
            },
            // Don't show the keyboard
            showCursor: true,
            readOnly: true,
          ),
      ]
    );
  }
}

const List<String> list = <String>['minutes', 'hours', 'days'];
class TimeInterval extends StatefulWidget {
  TimeInterval(this.howManyController, this._setTimeUnit, {super.key});

  final TextEditingController howManyController;
  final Function(String val) _setTimeUnit;
  @override
  State<StatefulWidget> createState() => _TimeIntervalState();
}

class _TimeIntervalState extends State<TimeInterval> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.howManyController,
          maxLength: 30,
          decoration: const InputDecoration(
            labelText: "How many",
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter reminder timing';
            }
            if(int.tryParse(value) == null) {
              return 'Please enter a number';
            }
            return null;
          },
        ),

        DropdownMenu<String>(
          initialSelection: list.first,
          onSelected: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              dropdownValue = value!;
            });
            widget._setTimeUnit(value!);
          },
          dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(value: value, label: value);
          }).toList(),
        )
      ],
    );
  }
}

class TimingSelection extends StatelessWidget {
  const TimingSelection(
      this.selectedOption, this.howManyController, this.dateController, this.timeController, this._selectTime, this._setTimeUnit, {super.key});
  final int selectedOption;
  final TextEditingController howManyController;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final Function() _selectTime;
  final Function(String val) _setTimeUnit;

  @override
  Widget build(BuildContext context) {
    if (selectedOption == 1) {
      return TimeInterval(howManyController, _setTimeUnit);
    }
    if (selectedOption == 2) {
      return DateAndTime(dateController, timeController, _selectTime);
    }
    else {
      return Text("error with selection");
    }
  }
}


class NewReminderForm extends StatefulWidget {
  const NewReminderForm(this.nameController, this.howManyController, this.dateController, this.timeController, this._selectTime, this._setReminderType, this._setTimeUnit, {super.key});//this.setTypeFunction, 

  final TextEditingController nameController;
  final TextEditingController howManyController;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final Function() _selectTime;
  final Function(int val) _setReminderType;
  final Function(String val) _setTimeUnit;

  @override
  State<NewReminderForm> createState() => _NewReminderFormState();
}

class _NewReminderFormState extends State<NewReminderForm> {
  int selectedOption = 1; 

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Column(
        children: <Widget>[

          // Reminder Name
          TextFormField(
            controller: widget.nameController,
            maxLength: 30,
            decoration: const InputDecoration(
              labelText: "Remind me about",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter reminder content';
              }
              return null;
            },
          ),

          // Radio buttons 
          ListTile(
            title: const Text('in'),
            leading: Radio<int>(
              value: 1,
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value!;
                });
                widget._setReminderType(1);
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
                widget._setReminderType(2);
              },
            ),
          ),

          // Set time 
          TimingSelection(selectedOption, widget.howManyController, widget.dateController, widget.timeController, widget._selectTime, widget._setTimeUnit),

        ],
      )
    ],);
  }

}