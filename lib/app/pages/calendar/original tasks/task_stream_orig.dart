import 'package:babysteps/app/pages/calendar/calendar_database.dart';
import 'package:babysteps/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

/// The widget that reads realtime Task updates.
class TaskStream extends StatefulWidget {
  DateTime selectedDay;
  TaskStream({required this.selectedDay, super.key});

  @override
  _TaskStreamState createState() => _TaskStreamState();
}

class _TaskStreamState extends State<TaskStream> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> taskStream = CalendarDatabaseMethods()
        .getTaskStream(widget.selectedDay, currentUser.value!.userDoc);

    return StreamBuilder<QuerySnapshot>(
      stream: taskStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // An array of Task documents
        var taskDocs = snapshot.data!.docs;

        if (taskDocs.isEmpty) {
          return const Text("No tasks today.");
        } else {
          return ListView(
            shrinkWrap:
                true, // TODO We can make this a SizedBox and it will scroll by default. But, the box is not obviously scrollable.
            children: taskDocs
                .map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  var docId = document.id;
                  return CheckboxListTile(
                    // TODO add this back if we want Tasks to have associated times
                    // title: Row(
                    //   children: [Text(data['name']),
                    //              const Text(" at "),
                    //              Text(DateFormat('hh:mm').format(data['dateTime'].toDate()))]
                    // ),
                    title: Text(data['name']),
                    subtitle: Text("reminder at 10:00"),
                    value: data['completed'],
                    onChanged: (bool? value) async {
                      // Write updated task data to database
                      Map<String, dynamic> updateData = {
                        'name': data['name'],
                        'dateTime': data['dateTime'],
                        'completed': !data['completed'],
                      };
                      await CalendarDatabaseMethods().updateTask(
                          docId, updateData, currentUser.value!.userDoc);
                    },
                  );
                })
                .toList()
                .cast(),
          );
        }
      },
    );
  }
}
