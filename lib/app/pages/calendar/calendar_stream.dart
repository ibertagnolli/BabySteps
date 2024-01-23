import 'package:babysteps/app/pages/calendar/calendar_database.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'event.dart';

/// The widget that reads realtime weight updates for the dropdown list of events in calendar.
class CalendarStream extends StatefulWidget {
  const CalendarStream({super.key});

  @override
  State<StatefulWidget> createState() => _CalendarStreamState();
}

class _CalendarStreamState extends State<CalendarStream> {
  final Stream<QuerySnapshot> _calendarStream =
      CalendarDatabaseMethods().getStream();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _calendarStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // An array of documents, but our query only returns an array of one document
        var lastEventDoc = snapshot.data!.docs;

        DateTime date = DateTime.parse(lastEventDoc[0]['date'].toString());
        String diff = DateTime.now().difference(date).inMinutes.toString();
        //TODO: Not sure how to get the correct selected events here, we need to pull just the events on that day to list
         Map<DateTime, List<Event>> events = lastEventDoc[0]['events'];
         ValueNotifier<List<Event>> _selectedEvents = events as ValueNotifier<List<Event>>;

        // Returns the expansion tile with read values for the list of events
        // updated in real time.
       return ExpansionTile(
             backgroundColor: Theme.of(context).colorScheme.surface,
             collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
             title: Text('Calendar Events',
                 style: TextStyle(
                     fontSize: 20,
                     color: Theme.of(context).colorScheme.onSurface,
                     fontWeight: FontWeight.bold)),
             children: <Widget>[
               SizedBox(
                 height: 100,
                 child: ValueListenableBuilder(
                     valueListenable: _selectedEvents,
                     builder: (context, value, _) {
                       return ListView.builder(
                           itemCount: value.length, //should this be events
                           itemBuilder: (context, index) {
                             return Container(
                               child: ListTile(
                                   onTap: () => Text('$value'),
                                   title: Text('${value[index]}')),
                             );
                           });
                     }),
               ),
               //const ListTile(title: Text('No new milestones to be aware of')),
             ],
           );
      },
    );
  }
}
