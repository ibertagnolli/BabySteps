import 'package:babysteps/app/pages/home/reminders/reminders_database.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';

/// Each card shows a reminder on the home page
class ReminderCard extends StatelessWidget {
  final String name;
  final docId;
  final context; // TODO if we make this a Stateful widget, we'll have access to context outside of build()

  const ReminderCard(this.name, this.docId,
      {super.key, this.context}); // this.context

  /// Deletes the selected Reminder from the database
  Future<void> deleteReminder() async {
    await RemindersDatabaseMethods()
        .deleteReminder(docId, currentUser.value!.userDoc);
  }

  /// Opens the Reminder for edits
  void editReminder() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => EditRemindersStream(docId)),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: () => editReminder(),
        splashColor: Theme.of(context).colorScheme.surface,
        child: SizedBox(
          width: 200,
          height: 80,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Reminder name
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    // TODO We can add this easily, just need to make the widget Stateful. Do we want it?
                    // Text(
                    //   "Last edited at $lastEdited" " o'clock",
                    // ),
                  ],
                ),
              ),
              const Expanded(
                  child: SizedBox(
                width: 30,
                height: 80,
              )),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Align(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Delete button
                      IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      // Dialog confirming user wants to delete the reminder
                                      return AlertDialog(
                                          title: Text(
                                              "Do you want to delete \"$name\"?"),
                                          actions: <Widget>[
                                            TextButton(
                                                child: const Text('Yes'),
                                                onPressed: () {
                                                  deleteReminder();
                                                  Navigator.of(context).pop();
                                                }),
                                            TextButton(
                                                child: const Text('No'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                })
                                          ]);
                                    })
                              }),

                      // Edit button
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => editReminder(),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}