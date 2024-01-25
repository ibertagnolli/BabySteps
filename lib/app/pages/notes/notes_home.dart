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
  DateTime lastEdited = DateTime.now();
  static List<String> notes = ["Dr Appointment Questions", "Allergies", "Vaccines", "To Do List",];


//Navigate to next page if the user clicks a note in the list builder
void _editNote() {
     Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotesPage()),
                  );
    }

//TODO: remove it from the database and screen
_deleteNote() {
  //notes.removeAt(index);
    // setState(() {
    //   notes.removeAt(index);
    // });
  }



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
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (BuildContext context, int index) {
            return NotesCard(notes[index], lastEdited.hour.toString(), index, _editNote, _deleteNote);
            // return ListTile(
            //     //leading: CircleAvatar(child:Text(notes[index])),
            //     trailing:
            //             Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            //           IconButton(
            //             icon: Icon(Icons.delete),
            //             onPressed: () => _deleteNote(index),
            //           ),
            //           IconButton(
            //               icon: Icon(Icons.edit),
            //               onPressed: () => _editNote(index)),
            //             ],
            //             ),
            //     title: Text(notes.elementAt(index))
            // );
          }),
      ),
    );
    // );
  }
}
