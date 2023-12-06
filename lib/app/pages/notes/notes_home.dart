import 'package:babysteps/app/pages/notes/notes.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class NotesHomePage extends StatefulWidget {
  const NotesHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Notes'),
        leading: const Padding(
          padding: EdgeInsets.all(8),
          child: Image(
            image: AssetImage('assets/BabyStepsLogo.png'),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Text("Notes Folders",
                  style: TextStyle(
                      fontSize: 36,
                      color: Theme.of(context).colorScheme.onBackground)),
            ),
            TrackingCard(
              const Icon(Icons.medical_services, size: 40),
              "Medical",
              "6 days ago",
              () => context.go('/notes/medical'),
            ),
            TrackingCard(const Icon(Icons.flag, size: 40), "Milestones",
                "3 weeks ago", () => context.go('/notes/milestone')),
            TrackingCard(const Icon(Icons.scale, size: 40), 'Growth',
                '3 hours ago', () => context.go('/notes/growth')),
            TrackingCard(const Icon(Icons.settings, size: 40), "Orginization",
                "2 months ago", () => context.go('/notes/organization')),
          ],
        ),
      ),
    );
    // );
  }
}
