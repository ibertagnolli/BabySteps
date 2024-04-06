import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class DateAndTime extends StatelessWidget {
  const DateAndTime(
      this.dateController, this.timeController, {super.key});
  final TextEditingController dateController;
  final TextEditingController timeController;

  @override
  Widget build(BuildContext context) {
    DateTime initDate = DateFormat("MM/dd/yyyy").parse(dateController.text);

    List<String> splitTime = timeController.text.split(' '); // format 2:00 PM
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
            showCursor: true,
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
            showCursor: true,
            readOnly: true,
          ),
      ]
    );
  }
}


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
    else {
      return Text("error with selection");
    }
  }
}


class NewReminderForm extends StatefulWidget {
  const NewReminderForm(this.nameController, this.howManyController, this.dateController, this.timeController, this._setReminderType, this._setTimeUnit, this.initUnitSelection, this.initRadioButton, {super.key});//this.setTypeFunction, 

  final TextEditingController nameController;
  final TextEditingController howManyController;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final Function(int val) _setReminderType;
  final Function(String val) _setTimeUnit;
  final String initUnitSelection;
  final int initRadioButton;

  @override
  State<NewReminderForm> createState() => _NewReminderFormState();
}

class _NewReminderFormState extends State<NewReminderForm> {
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
          TimingSelection(selectedOption, widget.howManyController, widget.dateController, widget.timeController, widget._setTimeUnit, widget.initUnitSelection),

        ],
      )
    ],);
  }

}