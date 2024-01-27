import 'package:babysteps/app/pages/calendar/add_event_button.dart';
import 'package:babysteps/app/pages/calendar/calendar_database.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/checkList.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:go_router/go_router.dart';
import 'dart:core';

import 'event.dart';

class CalendarPage extends StatefulWidget {
 const CalendarPage({super.key});

 @override
 State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  ///TODO: get these list items from the notes page!!!!!!!!!!!???????????????
  static List<String> items = ["Fold laundry", "Cook dinner", "Sweep floors"];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now(); // The current day
  DateTime _selectedDay = DateTime.now(); // The day selected in the calendar
  DateTime kFirstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
  DateTime kLastDay = DateTime(
      DateTime.now().year, DateTime.now().month + 3, DateTime.now().day);
  //Variables for list of events/ event handling
  late final ValueNotifier<List<Event>> _selectedEvents;
  Map<DateTime, List<Event>> events = {};

//Upload data to database with existing events?
  uploadData() async {
    Map<String, dynamic> uploaddata = {
      'events':
          events, //this is a list of events right now does that need to change?
      'date': DateTime.now().toIso8601String(),
    };

    await CalendarDatabaseMethods().addEvent(uploaddata);
    //once data has been added, update the calendar accordingly
  }

//Grab the data on page initialization
  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    CalendarDatabaseMethods().listenForEventReads();
  }

// TODO: this needs to pull the list of events from the database!!
  List<Event> _getEventsForDay(DateTime day) {
    //retrieve all events from the selected day.
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Calendar'),
        leading: const Padding(
          padding: EdgeInsets.all(8),
          child: Image(
            image: AssetImage('assets/BabyStepsLogo.png'),
          ),
        ),
      ),
      body: Center(
        child: ListView(children: <Widget>[

          // Calendar Title
          Padding(
            padding: const EdgeInsets.all(32),
            child: Text('Calendar',
                style: TextStyle(
                    fontSize: 36,
                    color: Theme.of(context).colorScheme.onBackground)),
          ),
          
          //TODO:This is causing an error right now since we aren't actually saving the list of events correctly for the stream to access
          // Table Calendar
          // const Padding(
          //   padding: EdgeInsets.only(bottom: 16),
          //   child: SizedBox(
          //     height: 200,
          //     child: CalendarStream(),
          //   ),
          // ),

         Padding(
           padding: EdgeInsets.only(bottom: 15),
           child: TableCalendar(
             firstDay: DateTime.utc(2023, 10, 16),
             lastDay: DateTime.utc(2025, 3, 14),
             focusedDay: DateTime.now(),
             eventLoader: _getEventsForDay,
             selectedDayPredicate: (day) {
               // Use `selectedDayPredicate` to determine which day is currently selected.
               // If this returns true, then `day` will be marked as selected.


                // Using `isSameDay` is recommended to disregard
                // the time-part of compared DateTime objects.
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _selectedEvents.value = _getEventsForDay(selectedDay);
                  });
                }
              },
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
            ),
          ),
          
          // Add event button
          Padding(
            padding: const EdgeInsets.all(15),
            child: AddEventButton(selectedDay: _selectedDay,),
          ),
          
          // To do list card
          Padding(
            padding: const EdgeInsets.all(15),
            child: ExpansionTile(
              backgroundColor: Theme.of(context).colorScheme.surface,
              collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
              title: Text('To Do',
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold)),
              children: <Widget>[
                CheckboxListTileExample(items),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: const Icon(Icons.note),
                      tooltip: 'Go to To Do note',
                      onPressed: () => context.go('/notes/organization/todo'),
                      // setState(() {

                     // });
                   ),
                 ),
               ),
             ],
           ),
         ),


          // // Milestones Card
          // Padding(
          //   padding: EdgeInsets.all(15),
          //   child: ExpansionTile(
          //     backgroundColor: Theme.of(context).colorScheme.surface,
          //     collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
          //     title: Text('Milestones',
          //         style: TextStyle(
          //             fontSize: 20,
          //             color: Theme.of(context).colorScheme.onSurface,
          //             fontWeight: FontWeight.bold)),
          //     children: <Widget>[
          //       ListTile(title: Text('No new milestones to be aware of')),
          //     ],
          //   ),
          // ),
          //events for that day on calendar.
          //TODO: use the stream to display this list of events?
          
          // Daily calendar events card
          Padding(
            padding: const EdgeInsets.all(15),
            child: ExpansionTile(
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
            ),
          ),
        ]),
      ),
    );
  }
}
