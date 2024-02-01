import 'package:babysteps/app/pages/calendar/calendar_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The widget that adds a new task.
class AddTaskButton extends StatefulWidget {
  DateTime selectedDay;
  AddTaskButton({required this.selectedDay, super.key});

  @override
  State<StatefulWidget> createState() => _AddTaskButtonState();
}

/// Stores the mutable data that can change over the lifetime of the AddTaskButton.
class _AddTaskButtonState extends State<AddTaskButton> {
  // The global key uniquely identifies the Form widget and allows 
  // validation of the form.
  final _formKey = GlobalKey<FormState>();

  // Store user input for database upload
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();        
    dateController.dispose();
    super.dispose();
  }

  /// Saves a new task entry in the Firestore database.
  saveNewTask() async {
    DateTime taskDate = DateFormat("MM/dd/yyyy").parse(dateController.text);

    // Write task data to database
    Map<String, dynamic> uploaddata = {
      'name': nameController.text,
      'dateTime': taskDate,
      'completed': false,
    };
    await CalendarDatabaseMethods().addTask(uploaddata);
    
    // Clear fields for next entry (not date)
    nameController.clear();
  }
  
  @override
  Widget build(BuildContext context) {
    // Now that widget has the passed selectedDay, populate the dateController
    dateController.text = DateFormat.yMd().format(widget.selectedDay);

    return SizedBox(
      // Add Task Button
      width: 170.0,
      height: 30.0,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Theme.of(context)
              .colorScheme
              .tertiary, // Background color
        ),
        child: Text("Add task",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary)),
        
        // Dialog with task entry
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                scrollable: true,
                title: const Text("New Task"),
                content: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Form(
                    key: _formKey,
                    child: Column (children: <Widget>[ 

                      // Task Name
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "Task",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the task name';
                          }
                          return null;
                        },
                      ),

                      // Task Date
                      TextFormField(
                        controller: dateController,
                        decoration: const InputDecoration(
                          labelText: "Date",
                        ),
                        onTap: () async {
                          // Don't show keyboard
                          FocusScope.of(context).requestFocus(new FocusNode());

                          DateTime? pickeddate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2050));

                          if (pickeddate != null) {
                            setState(() {
                              widget.selectedDay = pickeddate;
                              dateController.text =  DateFormat.yMd().add_jm().format(pickeddate);
                            });                      
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a date';
                          }
                          return null;
                        },
                      ),

                      // TODO add start time for task notifications 

                      // Submit button
                      ElevatedButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()) {
                            saveNewTask();
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