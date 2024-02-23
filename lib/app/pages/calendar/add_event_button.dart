import 'package:babysteps/app/pages/calendar/calendar_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// The widget that adds a new event.
class AddEventButton extends StatefulWidget {
  DateTime selectedDay;
  AddEventButton({required this.selectedDay, super.key});

  @override
  State<StatefulWidget> createState() => _AddEventButtonState();
}

/// Stores the mutable data that can change over the lifetime of the AddEventButton.
class _AddEventButtonState extends State<AddEventButton> {
  // The global key uniquely identifies the Form widget and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  // Store user input for database upload
  TextEditingController nameController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TimeOfDay eventTime = TimeOfDay.now();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();        
    timeController.dispose();
    dateController.dispose();
    super.dispose();
  }

  /// Gets the user's selected event time.
  void _selectTime() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (selectedTime != null) {   // TODO can selectedTime ever be null?
      setState(() {
        eventTime = selectedTime;
        timeController.text = selectedTime.format(context);
      });
    }
  }

  /// Saves a new event entry in the Firestore database.
  saveNewEvent() async {
    DateTime eventDate = DateFormat("MM/dd/yyyy").parse(dateController.text);
    DateTime eventDT = DateTime(eventDate.year, eventDate.month, eventDate.day, eventTime.hour, eventTime.minute);

    // Write event data to database
    Map<String, dynamic> uploaddata = {
      'name': nameController.text,
      'dateTime': eventDT,    // Stores the event date and its start time
    };
    await CalendarDatabaseMethods().addEvent(uploaddata);
    
    // Clear fields for next entry (not date)
    nameController.clear();
    timeController.clear();
  }
  
  @override
  Widget build(BuildContext context) {
    // Now that widget has the passed selectedDay, populate the dateController
    dateController.text = DateFormat.yMd().format(widget.selectedDay);

    return SizedBox(
      // Add Event Button
      width: 170.0,
      height: 30.0,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Theme.of(context)
              .colorScheme
              .tertiary, // Background color
        ),
        child: Text("Add event",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary)),
        
        // Dialog with event entry
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                scrollable: true,
                title: const Text("New Event"),
                content: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Form(
                    key: _formKey,
                    child: Column (children: <Widget>[

                      // Event Name
                      TextFormField(
                        controller: nameController,
                        maxLength: 30,
                        decoration: const InputDecoration(
                          labelText: "Event",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the event name';
                          }
                          return null;
                        },
                      ),

                      // Event Date
                      TextFormField(
                        controller: dateController,
                        decoration: const InputDecoration(
                          labelText: "Date",
                        ),
                        onTap: () async {
                          DateTime? pickeddate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2050));

                          if (pickeddate != null) {
                          // setState(() {
                              widget.selectedDay = pickeddate;
                              dateController.text =  DateFormat.yMd().add_jm().format(widget.selectedDay);
                           // });                      
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

                      // Event Start Time
                      TextFormField(
                        controller: timeController,
                        decoration: const InputDecoration(
                          labelText: "Start Time",
                        ),
                        onTap: _selectTime,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the event start time';
                          }
                          return null;
                        },
                        // Don't show the keyboard
                        showCursor: true,
                        readOnly: true,
                      ),

                      // Submit button
                      ElevatedButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()) {
                            saveNewEvent();
                            Navigator.pop(context);
                          }
                        }, 
                        child: const Text("Submit")
                      )
                    ],
                  )
                ),
              ));
            }
          );
        },
      ),
    );
  }
}