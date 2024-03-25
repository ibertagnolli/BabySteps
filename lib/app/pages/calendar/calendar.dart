import 'package:babysteps/app/pages/calendar/add_event_button.dart';
import 'package:babysteps/app/pages/calendar/add_milestone_button.dart';
import 'package:babysteps/app/pages/calendar/add_task_button.dart';
import 'package:babysteps/app/pages/calendar/event_stream.dart';
import 'package:babysteps/app/pages/calendar/milestone_stream.dart';
import 'package:babysteps/app/pages/calendar/task_stream.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
//import 'package:babysteps/app/pages/calendar/milestones.dart';
import 'package:babysteps/app/widgets/milestone_widgets.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:core';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _focusedDay = DateUtils.dateOnly(DateTime.now()); // The current day
  DateTime _selectedDay =
      DateUtils.dateOnly(DateTime.now()); // The day selected in the calendar
  DateTime? dob = currentUser.value!.currentBaby.value!.dob;
  late int monthsAlive;

//Grab the data on page initialization
  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    monthsAlive = (_selectedDay.difference(dob!).inDays / 30).floor();
  }

  @override
  Widget build(BuildContext context) {
      // Widgets
     return  Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          child: ListView(
            children: <Widget>[
              // Calendar Widget
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 10, 16),
                  lastDay: DateTime.utc(2050, 3, 14),
                  focusedDay: _focusedDay,
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
                        _selectedDay = DateUtils.dateOnly(selectedDay);
                        _focusedDay = DateUtils.dateOnly(focusedDay);
                        monthsAlive =
                            (_selectedDay.difference(dob!).inDays / 30).floor();
                        int exactDay =
                            _selectedDay.difference(dob!).inDays % 30;
                        if (exactDay == 0) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("New Month!"),
                                content: Text(
                                  "Your baby is now $monthsAlive months old! Check out the milestones tab to see the recommended CDC milestones, or to add your own!",
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Ok'),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Dismiss the dialog
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        if (monthsAlive <= 0) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Heads Up!"),
                                content: const Text(
                                  "You are selecting a date before your child was born. No milestones, events, or tasks will appear before your child was born.",
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Ok'),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Dismiss the dialog
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
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
                    _focusedDay = DateUtils.dateOnly(focusedDay);
                  },
                ),
              ),

              // Daily calendar events card
              Padding(
                padding: const EdgeInsets.all(15),
                child: ExpansionTile(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  collapsedBackgroundColor:
                      Theme.of(context).colorScheme.surface,
                  title: Text(
                      'Events on ${DateFormat.Md().format(_selectedDay)}',
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold)),
                  initiallyExpanded: true,
                  children: <Widget>[
                    // List of events
                    EventStream(
                      selectedDay: _selectedDay,
                    ),

                    // Add event button
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: AddEventButton(
                        selectedDay: _selectedDay,
                      ),
                    ),
                  ],
                ),
              ),

              // Daily Calendar tasks card
              Padding(
                padding: const EdgeInsets.all(15),
                child: ExpansionTile(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  collapsedBackgroundColor:
                      Theme.of(context).colorScheme.surface,
                  title: Text(
                      'Tasks for ${DateFormat.Md().format(_selectedDay)}',
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold)),
                  initiallyExpanded: true,
                  children: <Widget>[
                    // List of tasks
                    TaskStream(
                      selectedDay: _selectedDay,
                    ),

                    // Add task button
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: AddTaskButton(
                        selectedDay: _selectedDay,
                      ),
                    ),
                  ],
                ),
              ),
              //Daily milestones card
              Padding(
                padding: const EdgeInsets.all(15),
                child: ExpansionTile(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  collapsedBackgroundColor:
                      Theme.of(context).colorScheme.surface,
                  title: Text('Milestones for $monthsAlive months',
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold)),
                  initiallyExpanded: true,
                  children: <Widget>[
                    MilestonesWidget(monthsAlive: monthsAlive),
                    // List of milestones
                    Text("Personal Milestones", style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                    MilestoneStream(
                      selectedDay: _selectedDay,
                    ),
                    // Add task button
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          AddMilestoneButton(
                            selectedDay: _selectedDay,
                          ),
                          SizedBox(
                            // Add Task Button
                            width: 170.0,
                            height: 30.0,
                            child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .tertiary, // Background color
                                ),
                                child: Text("Add Post",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary)),

                                //go to new post page
                                onPressed: () => context.go('/social/newPost')),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
   //   ),
    );
  }
}
