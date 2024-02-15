import 'package:babysteps/app/pages/notes/notes.dart';
import 'package:babysteps/app/pages/notes/notes_database.dart';
import 'package:babysteps/app/pages/notes/notes_stream.dart';
import 'package:flutter/material.dart';

class NotesHomePage extends StatefulWidget {
  const NotesHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _NotesHomePageState();
}

/// Home landing page that displays all the notes
class _NotesHomePageState extends State<NotesHomePage> {
  // Navigate to next page if the user clicks a note in the list builder
  void _openNote() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotesPage("", "", "")), // Open a new NotesPage
    );
  }

  // Grab the data on page initialization
  @override
  void initState() {
    super.initState();
    NoteDatabaseMethods().listenForNoteReads();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Navigation Bar
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Notes'),
        leading: const Padding(
          padding: EdgeInsets.all(8),
          child: Image(
            image: AssetImage('assets/BabyStepsLogo.png'),
          ),
        ),
      ),
      
      // List of notes
      body: Column(
        children: [
          const Flexible(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: NotesStream(),
            ),
          ),
          //   Flexible(
          // flex: 1,
          Expanded(
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                // Add note button
                // TODO have this button always float at the bottom, regardless of number of notes?
                child: ElevatedButton(
                  onPressed: _openNote,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.tertiary),
                    foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onTertiary),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  child: const Text('New Note'),
                )),
          ),
          //  )
        ],
      ),
    );
    // );
  }
}
