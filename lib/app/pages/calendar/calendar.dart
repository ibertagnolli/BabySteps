import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/checkList.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:core';

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
  DateTime? _selectedDay;
  DateTime kFirstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
  DateTime kLastDay = DateTime(
      DateTime.now().year, DateTime.now().month + 3, DateTime.now().day);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar',
      home: Scaffold(
        backgroundColor: const Color(0xffb3beb6),

        // Temporary Nav Bar
        appBar: AppBar(
          title: const Text('Calendar',
              style: TextStyle(fontSize: 36, color: Colors.black45)),
          backgroundColor: Color(0xFFFFFAF1),
        ),

        body: Center(
          child: ListView(children: <Widget>[
            // Weight Title
            const Padding(
              padding: EdgeInsets.all(32),
              child: Text('Calendar',
                  style: TextStyle(fontSize: 36, color: Color(0xFFFFFAF1))),
            ),

            // Very Very Basic calendar 
            //TODO: use api to flesh out calendar and make a more interactive calendar
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: TableCalendar(
                firstDay: DateTime.utc(2023, 10, 16),
                lastDay: DateTime.utc(2025, 3, 14),
                focusedDay: DateTime.now(),
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
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            // Call `setState()` when updating calendar format
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          // No need to call `setState()` here
          _focusedDay = focusedDay;
        },
        
            ),

            ),//To Do list card 
            //TODO: propogate todo items from variables through to the widget
            //TODO: add notes icon and integration at bottom of card 
            const Padding(
              padding: EdgeInsets.all(15),
              child: ExpansionTile(
                backgroundColor: Color(0xFFFFFAF1),
                collapsedBackgroundColor: Color(0xFFFFFAF1),
                title: Text('To Do',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                children: <Widget>[
                  CheckboxListTileExample(item1, item2, item3),
                ],
              ),
            ),

            // Milestones Card
            const Padding(
              padding: EdgeInsets.all(15),
              child: ExpansionTile(
                backgroundColor: Color(0xFFFFFAF1),
                collapsedBackgroundColor: Color(0xFFFFFAF1),
                title: Text('Milestones',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                children: <Widget>[
                  ListTile(title: Text('No new milestones to be aware of')),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
