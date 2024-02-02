import 'package:babysteps/time_since.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The cards on the Notes home page that a user clicks to open a note
class NotesCard extends StatelessWidget {
  const NotesCard(this.name, {super.key});
  final String name;

  void deleteNote() {

  }

  void editNote() {
    
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
                        onPressed: () => print("delete"), //deleteFunc(),
                      ),
                      // Edit button
                      IconButton(
                          icon: const Icon(Icons.edit), onPressed: () => print("edit"),//editFunc()),
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