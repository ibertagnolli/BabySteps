import 'package:babysteps/app/pages/notes/notes.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';

class NotesHomePage extends StatefulWidget {
  const NotesHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  @override
  Widget build(BuildContext context) {
    return
        // Scaffold(
        //   appBar: AppBar(
        //     backgroundColor: const Color(0xffb3beb6),
        //     title: const Text('Tracking'),
        //   ),
        //   body:
        Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Text("Notes",
                style: TextStyle(fontSize: 36, color: Theme.of(context).colorScheme.onBackground)),
          ),
          TrackingCard(
            const Icon(Icons.medical_services, size: 40),
            "Medical",
            "6 days ago",
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const NotesPage();
                  },
                ),
              );
            },
          ),
          TrackingCard(
            const Icon(Icons.flag, size: 40),
            "Milestones",
            "3 weeks ago",
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const NotesPage();
                  },
                ),
              );
            },
          ),
          TrackingCard(
            const Icon(Icons.scale, size: 40),
            'Growth',
            '3 hours ago',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotesPage()),
              );
            },
          ),
          TrackingCard(
            const Icon(Icons.settings, size: 40),
            "Orginization",
            "2 months ago",
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const NotesPage();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
    // );
  }
}
