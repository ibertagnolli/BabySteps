import 'package:babysteps/app/pages/notes/notes.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class NotesHomePage extends StatefulWidget {
  const NotesHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  String notename = "new note";
  static List<String> notes = ["Dr Appointment Questions", "Allergies", "Vaccines", "To Do List"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: 
      Padding(
        padding: EdgeInsets.all(15),
        child: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                //leading: const Icon(Icons.edit),
                // trailing:
                //         Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                //       IconButton(
                //         icon: Icon(Icons.delete),
                //         onPressed: () => _deleteNote(index),
                //       ),
                //       IconButton(
                //           icon: Icon(Icons.edit),
                //           onPressed: () => _editNote(index)),
                trailing: const Icon(Icons.edit),
                onTap: () {
                  //TODO: push to the note that is actually attached to the name of that list item
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotesPage()),
                  );
                },
                //notes.elementAt(index)
                title: Text(notes.elementAt(index)));
          }),
      ),
    );
    // );
  }
}
