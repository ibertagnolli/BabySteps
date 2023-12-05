import 'package:flutter/material.dart';
import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<StatefulWidget> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _noteController = TextEditingController();
  final List<String> _notes = [];
  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notes.addAll(prefs.getStringList('notes') ?? []);
    });
  }

  _saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('notes', _notes);
  }

  _addNote() {
    String newNote = _noteController.text;
    if (newNote.isNotEmpty) {
      setState(() {
        _notes.add(newNote);
      });
      _noteController.clear();
      _saveNotes();
    }
  }

_editNote(int index) {
    String newNote = _noteController.text;
    if (newNote.isNotEmpty) {
      setState(() {
        _notes.setAll(index, [newNote]);
      });
      _noteController.clear();
      _saveNotes();
    }
  }
  _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
    _saveNotes();
  }

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
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_notes[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children:<Widget>[ 
                     IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteNote(index),
                  ),
                  IconButton(icon: Icon(Icons.edit),
                  onPressed: () => _editNote(index)),]
                )
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Add a new note',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addNote,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
