import 'package:flutter/material.dart';
import 'dart:core';
import 'package:go_router/go_router.dart';
import 'package:babysteps/app/pages/home/reminders/reminders_stream.dart';
import 'package:babysteps/app/pages/home/reminders/add_reminder_button.dart';
import 'package:babysteps/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int numReminders = 0;
  DateTime _selectedDay = 
      DateUtils.dateOnly(DateTime.now()); 
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Home'),
        leading: const Padding(
          padding: EdgeInsets.all(8),
          child: Image(
            image: AssetImage('assets/BabyStepsLogo.png'),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () => context.go('/profile'),
              icon: const Icon(Icons.person))
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding: const EdgeInsets.all(15),),
            Text(
              'Welcome to BabySteps',
              style: TextStyle(
                  fontSize: 30.0, color: Theme.of(context).colorScheme.surface),
            ),
            SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset('assets/BabyStepsLogo.png',
                        fit: BoxFit.scaleDown)
              ),
            

            // Reminders
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 30, bottom: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Reminders', 
                  textAlign: TextAlign.left,
                  style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold)),
              )
            ),

            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: 
                // List of events
                RemindersStream(selectedDay: _selectedDay,)
            ),

            // Add reminder button
            Padding(
              padding: const EdgeInsets.all(15),
              child: AddReminderButton()
            ),
            
          ],
        ),
      
      ),
      ),   
    );
  }
}
