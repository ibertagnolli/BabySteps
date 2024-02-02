import 'package:babysteps/app/pages/notes/notes_database.dart';
import 'package:babysteps/time_since.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The cards on the Notes home page that a user clicks to open a note
class NotesCard extends StatelessWidget {
  const NotesCard(this.name, this.docId, {super.key});
  final String name;
  final docId;

  /// Deletes the selected Note from the database
  Future<void> deleteNote() async {
    await NoteDatabaseMethods().deleteNote(docId);
  }

  /// Opens the Note for edits
  void editNote() {
    print("edit");

  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        splashColor: Theme.of(context).colorScheme.surface,
        //onTap: pageFunc,
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
                    // Note name
                    Text(
                      name,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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

                              // Dialog confirming user wants to delete the note
                              return AlertDialog(
                                title: Text("Do you want to delete \"$name\"?"),
                                actions: <Widget> [
                                  TextButton(
                                    child: const Text('Yes'),
                                    onPressed: () {
                                      deleteNote();
                                      Navigator.of(context).pop();
                                    }
                                  ),
                                  TextButton(
                                    child: const Text('No'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    } 
                                  )
                                ]
                              );
                            }
                          )
                        }
                      ),
                      
                      // Edit button
                      IconButton(
                          icon: const Icon(Icons.edit), onPressed: () => editNote(),
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