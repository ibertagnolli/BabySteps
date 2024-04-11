import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


// The form that pops up where the user can create a reminder
class NewTaskForm extends StatefulWidget {
  const NewTaskForm(this.nameController, this.howManyController, this.dateController, this.timeController, this._setReminderType, this._setTimeUnit, this.initUnitSelection, this.initRadioButton, {super.key}); 
  
  final TextEditingController nameController;
  final TextEditingController howManyController;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final Function(int val) _setReminderType;
  final Function(String val) _setTimeUnit;
  final String initUnitSelection;
  final int initRadioButton;

  @override
  State<NewTaskForm> createState() => _NewTaskFormState();
}

class _NewTaskFormState extends State<NewTaskForm> {
  int selectedOption = 1;
  
  @override
  void initState() {
    setState(() {
      selectedOption = widget.initRadioButton;
    });
    super.initState();
  }
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
              labelText: "Task",
            ),
            onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the task.';
              }
              return null;
            },
          ),

          // Radio buttons 
          ListTile(
            title: const Text('Remind me in'),
            leading: Radio<int>(
              value: 1,
              groupValue: selectedOption,
              onChanged: (value) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                  selectedOption = value!;
                });
                widget._setReminderType(1);
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Remind me on'),
            leading: Radio<int>(
              value: 2,
              groupValue: selectedOption,
              onChanged: (value) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                  selectedOption = value!;
                });
                widget._setReminderType(2);
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Don\'t remind me'),
            leading: Radio<int>(
              value: 3,
              groupValue: selectedOption,
              onChanged: (value) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                  selectedOption = value!;
                });
                widget._setReminderType(3);
                });
              },
            ),
          ),

          // Set time 
          TimingSelection(selectedOption, widget.howManyController, widget.dateController, widget.timeController, widget._setTimeUnit, widget.initUnitSelection),
        ],
      )
    ],);
  }
}


// Displays the correct timing options depending on the radio button
class TimingSelection extends StatelessWidget {
  const TimingSelection(
      this.selectedOption, this.howManyController, this.dateController, this.timeController, this._setTimeUnit, this.initUnitSelection, {super.key});

  final int selectedOption;
  final TextEditingController howManyController;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final Function(String val) _setTimeUnit;
  final String initUnitSelection;

  @override
  Widget build(BuildContext context) {
    if (selectedOption == 1) {
      return TimeInterval(howManyController, _setTimeUnit, initUnitSelection);
    }
    if (selectedOption == 2) {
      return DateAndTime(dateController, timeController);
    }
    if (selectedOption == 3) {
      return const Text("");
    }
    else {
      return const Text("error with selection");
    }
  }
}


// Text for user to pick a number, and a dropdown for the associated time unit (minutes, hours, days)
const List<String> list = <String>['minutes', 'hours', 'days'];
class TimeInterval extends StatefulWidget {
  TimeInterval(this.howManyController, this._setTimeUnit, this.initUnitSelection, {super.key});

  final TextEditingController howManyController;
  final Function(String val) _setTimeUnit;
  final String initUnitSelection;
  @override
  State<StatefulWidget> createState() => _TimeIntervalState();
}

class _TimeIntervalState extends State<TimeInterval> {
  String dropdownValue = list.first;

  @override
  void initState() {
    setState(() {
      dropdownValue = widget.initUnitSelection;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Text input
        TextFormField(
          controller: widget.howManyController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          maxLength: 30,
          decoration: const InputDecoration(
            labelText: "How many",
          ),
          onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter reminder timing';
            }
            return null;
          },
        ),

        // Dropdown for units
        DropdownMenu<String>(
          initialSelection: widget.initUnitSelection,
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


// Date and time pickers 
class DateAndTime extends StatelessWidget {
  const DateAndTime(
      this.dateController, this.timeController, {super.key});
  final TextEditingController dateController;
  final TextEditingController timeController;

  @override
  Widget build(BuildContext context) {
    
    DateTime initDate = DateFormat("MM/dd/yyyy").parse(dateController.text);

    List<String> splitTime = timeController.text.split(' '); // format like 2:00 PM
    List<String> splitHrMin = splitTime[0].split(':');
    String dayNight = splitTime[1];
    int hr = int.parse(splitHrMin[0]);
    if(dayNight == "PM") {
      hr += 12;
    }
    int min = int.parse(splitHrMin[1]);
    TimeOfDay initTime = TimeOfDay(hour: hr, minute: min);

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
                  initialDate: initDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2050));
              if (pickedDate != null) {
                dateController.text = DateFormat.yMd()
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
            showCursor: false,
            readOnly: true,
          ),

          // Reminder Time
          TextFormField(
            controller: timeController,
            decoration: const InputDecoration(
              labelText: "Time",
            ),
            onTap: () async {
              final TimeOfDay? selectedTime = await showTimePicker( 
              initialTime: initTime,
              context: context,
              );
              if (selectedTime != null) {
                timeController.text = selectedTime.format(context);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter reminder time';
              }
              return null;
            },
            // Don't show the keyboard
            showCursor: false,
            readOnly: true,
          ),
      ]
    );
  }
}