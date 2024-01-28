import 'package:babysteps/app/pages/calendar/add_event_button.dart';
import 'package:babysteps/app/pages/calendar/add_task_button.dart';
import 'package:babysteps/app/pages/calendar/calendar_database.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/checkList.dart';
import 'package:intl/intl.dart';
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
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _focusedDay = DateTime.now(); // The current day
  DateTime _selectedDay = DateTime.now(); // The day selected in the calendar
  DateTime kFirstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
  DateTime kLastDay = DateTime(
      DateTime.now().year, DateTime.now().month + 3, DateTime.now().day);
  //Variables for list of events/ event handling
  late final ValueNotifier<List<Event>> _selectedEvents;
  Map<DateTime, List<Event>> events = {};

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
        child: Padding(
          padding: EdgeInsets.only(top: 15, bottom: 15),
          child: ListView(children: <Widget>[      
            // Calendar
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
                    // TODO update so displayed weeks are based on selected date as frame of reference
                  });
                },
                onPageChanged: (focusedDay) {
                  // No need to call `setState()` here
                  _focusedDay = focusedDay;
                },
              ),
            ),
            
            // Daily calendar events card
            Padding(
              padding: const EdgeInsets.all(15),
              child: ExpansionTile(
                backgroundColor: Theme.of(context).colorScheme.surface,
                collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
                title: Text('Events on ${DateFormat.Md().format(_selectedDay)}',
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold)),
                initiallyExpanded: true,
                children: <Widget>[
                  // List of events
                  SizedBox(
                    height: 100, // TODO edit this to be sized based on space, not set value
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
                  
                  // Add event button
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: AddEventButton(selectedDay: _selectedDay,),
                  ),

                ],
              ),
            ),

            // To do list card
            Padding(
              padding: const EdgeInsets.all(15),
              child: ExpansionTile(
                backgroundColor: Theme.of(context).colorScheme.surface,
                collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
                title: Text('Tasks for ${DateFormat.Md().format(_selectedDay)}',
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold)),
                initiallyExpanded: true,
                children: <Widget>[
                  // List of tasks
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

                  // Add task button
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: AddTaskButton(selectedDay: _selectedDay,),
                  ),
              ],
            ),
            ),

            // // Add task button
            // Padding(
            //   padding: const EdgeInsets.all(15),
            //   child: AddEventButton(selectedDay: _selectedDay,),
            // ),           
          ]),
        )
      ),
    );
  }
}
