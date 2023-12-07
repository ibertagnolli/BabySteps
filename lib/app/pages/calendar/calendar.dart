import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/checkList.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:core';

import 'event.dart';

//TODO: add navigation to this page from any page.
//This next line allows me to run the calendar page as main since we don't have the navigation to the calendar page setup yet.
//void main() => runApp(const CalendarPage());

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  //TODO: propagate these item strings through to the checklist box
  static const String item1 = "3";
  static const String item2 = "101.5";
  static const String item3 = "do dishes";
  String buttonText = "Add Temp";
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  DateTime kFirstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
  DateTime kLastDay = DateTime(
      DateTime.now().year, DateTime.now().month + 3, DateTime.now().day);
  Map<DateTime, List<Event>> events = {};
  TextEditingController _eventController = TextEditingController();
  late final ValueNotifier<List<Event>> _selectedEvents;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

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
          // Weight Title
          Padding(
            padding: EdgeInsets.all(32),
            child: Text('Calendar',
                style: TextStyle(fontSize: 36, color: Theme.of(context).colorScheme.onBackground)),
          ),

          // Very Very Basic calendar
          //TODO: use api to flesh out calendar and make a more interactive calendar
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
              //TODO: will need these later for customizing formatting and page changing
              // onFormatChanged: (format) {
              //   if (_calendarFormat != format) {
              //     // Call `setState()` when updating calendar format
              //     setState(() {
              //       _calendarFormat = format;
              //     });
              //   }
              // },
              // onPageChanged: (focusedDay) {
              //   // No need to call `setState()` here
              //   _focusedDay = focusedDay;
              // },
            ),
          ), //To Do list card
          Padding(
            padding: EdgeInsets.all(15),
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.secondary, // Background color
              ),
              child: Text("Add event", style: TextStyle( color: Theme.of(context).colorScheme.onSecondary)),
              onPressed: () {
                //show dialog for the user to input event
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        scrollable: true,
                        title: Text("Event Name"),
                        content: Padding(
                          padding: EdgeInsets.all(8),
                          child: TextField(
                            controller: _eventController,
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                events.addAll({
                                  _selectedDay!: [Event(_eventController.text)]
                                });
                                Navigator.of(context).pop();
                                _selectedEvents.value =
                                    _getEventsForDay(_selectedDay!);
                              },
                              child: const Text("Submit"))
                        ],
                      );
                    });
              },
            ),
          ),
          //TODO: propogate todo items from variables through to the widget
          //TODO: add notes icon and integration at bottom of card
          Padding(
            padding: EdgeInsets.all(15),
            child: ExpansionTile(
              backgroundColor: Theme.of(context).colorScheme.surface,
              collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
              title: Text('To Do',
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold)),
              children: <Widget>[
                CheckboxListTileExample(item1, item2, item3),
              ],
            ),
          ),

          // Milestones Card
          Padding(
            padding: EdgeInsets.all(15),
            child: ExpansionTile(
              backgroundColor: Theme.of(context).colorScheme.surface,
              collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
              title: Text('Milestones',
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold)),
              children: <Widget>[
                ListTile(title: Text('No new milestones to be aware of')),
              ],
            ),
          ),
          //events for that day on calendar.
          Padding(
            padding: EdgeInsets.all(15),
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
                            itemCount: value.length,
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
