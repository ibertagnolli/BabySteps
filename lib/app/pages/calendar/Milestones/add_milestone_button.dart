import 'package:babysteps/app/pages/calendar/calendar_database.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The widget that adds a new Milestone.
class AddMilestoneButton extends StatefulWidget {
  DateTime selectedDay;
  AddMilestoneButton({required this.selectedDay, super.key});

  @override
  State<StatefulWidget> createState() => _AddMilestoneButtonState();
}

/// Stores the mutable data that can change over the lifetime of the AddMilestoneButton.
class _AddMilestoneButtonState extends State<AddMilestoneButton> {
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

  /// Saves a new Milestone entry in the Firestore database.
  saveNewMilestone() async {
    DateTime milestoneDate =
        DateFormat("MM/dd/yyyy").parse(dateController.text);

    // Write Milestone data to database
    Map<String, dynamic> uploaddata = {
      'name': nameController.text,
      'dateTime': milestoneDate,
    };

    await CalendarDatabaseMethods()
        .addMilestone(uploaddata, currentUser.value!.userDoc);

    // Clear fields for next entry (not date)
    nameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Now that widget has the passed selectedDay, populate the dateController
    dateController.text = DateFormat.yMd().format(widget.selectedDay);

    return SizedBox(
      // Add Milestone Button
      width: 170.0,
      height: 30.0,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor:
                Theme.of(context).colorScheme.tertiary, // Background color
          ),
          child: const Text("Add Milestone",
              style: TextStyle(fontSize: 15, color: Colors.white)),

          // Dialog with Milestone entry
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      scrollable: true,
                      title: const Text("New Milestone"),
                      content: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                //Milestone Name/info
                                TextFormField(
                                  controller: nameController,
                                  maxLength: 100,
                                  decoration: const InputDecoration(
                                    labelText: "Milestone",
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the Milestone name';
                                    }
                                    return null;
                                  },
                                ),

                                // Milestone Date
                                TextFormField(
                                  controller: dateController,
                                  decoration: const InputDecoration(
                                    labelText: "Date",
                                  ),
                                  onTap: () async {
                                    // Don't show keyboard
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());

                                    DateTime? pickeddate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2020),
                                        lastDate: DateTime(2050));

                                    if (pickeddate != null) {
                                      dateController.text =
                                          DateFormat.yMd().format(pickeddate);
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a date';
                                    }
                                    return null;
                                  },
                                ),

                                // Submit button
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        //TODO change to save new milestone
                                        saveNewMilestone();
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text("Submit",
                                        style: TextStyle(color: Colors.white)))
                              ],
                            )),
                      ));
                });
          },
        ),
      ),
    );
  }
}
