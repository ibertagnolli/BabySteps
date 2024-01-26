import 'package:flutter/material.dart';
import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<StatefulWidget> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  //TODO: probably want to store the date/time the note is added, title and contents in DB
  DateTime date = DateTime.now();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Notes'),
          leading: BackButton(
            color: Theme.of(context).colorScheme.onSurface,
            onPressed: () => Navigator.of(context).pop(),
          )),
      body: Column(
        children: <Widget>[
          //The text field and styling for adding the note title 
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.multiline,
              maxLines: 1,
              controller: _titleController,
              style: TextStyle(
                  fontSize: 25,
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Note Title",
                hintStyle: TextStyle(
                    fontSize: 25,
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),

         //The text field and styling for writing the note contents.
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _noteController,
                  style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Add to note",
                      hintStyle: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),

          //Elevated button to save the note
          Expanded(
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: ElevatedButton(
                  //TODO: connect to BE so when they save it adds note to DB
                  onPressed:() {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.tertiary),
                    foregroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.onTertiary),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  child: const Text('Save Note'),
                )),
          ),
        ],
      ),
    );
  }
}
