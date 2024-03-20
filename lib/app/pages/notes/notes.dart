import 'package:babysteps/app/pages/notes/notes_database.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class NotesPage extends StatefulWidget {
  final String title;
  final String contents;
  var docId;
  String noteTitle = "";

  NotesPage(this.docId, this.title, this.contents, {super.key});

  @override
  State<StatefulWidget> createState() => _NotesPageState();
}

/// The page where users write/edit Notes.
class _NotesPageState extends State<NotesPage> {
  late final TextEditingController _noteController =
      TextEditingController(text: widget.contents);
  late final TextEditingController _titleController =
      TextEditingController(text: widget.title);

  // The global key uniquely identifies the Form widget and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  /// Saves a new event entry in the Firestore database if the entry does not already exist.
  /// Otherwise, updates the existing entry
  saveNote() async {
    // TODO add date if we want to tell the user last time they updated

    // Write Note data to database
    Map<String, dynamic> uploaddata = {
      'title': _titleController.text,
      'contents': _noteController.text,
    };

    // Add a new note if the docId isn't specified. Else, update the existing Document.
    if (widget.docId == "") {
      await NoteDatabaseMethods()
          .addNote(uploaddata, currentUser.value!.currentBaby.value!.collectionId);
    } else {
      await NoteDatabaseMethods().updateNote(widget.docId, uploaddata,
          currentUser.value!.currentBaby.value!.collectionId);
    }

    // Clear fields for next entry (not date)
    _noteController.clear();
    _titleController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,

      // Navigation Bar
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Notes'),
          leading: BackButton(
            color: Theme.of(context).colorScheme.onSurface,
            onPressed: () => Navigator.of(context).pop(),
          )),

      // Using a form to ensure all fields have data before saving
      // Using single child scroll view to fix overflow error
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            // Note title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _titleController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.multiline,
                maxLines: 1,
                maxLength: 20,
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the note title.';
                  }
                  return null;
                },
              ),
            ),

            // Note contents
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please write the note contents.';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),

            //Elevated button to save the note
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  saveNote();
                  Navigator.pop(context);
                }
              },
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
            )
          ]),
        ),
      ),
    );
  }
}
