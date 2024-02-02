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
      body: 
       SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
            Padding(
              padding: EdgeInsets.only(top: 32),
              child: 
            TrackingCard(
              icon:const Icon(Icons.medical_services, size: 40),
              name:"Medical",
              hoursAgo: "6 days ago",
             pageFunc:  () => context.go('/notes/medical'),
            ),),
            TrackingCard(icon:const Icon(Icons.flag, size: 40),name: "Milestones",
               hoursAgo: "3 weeks ago", pageFunc: () => context.go('/notes/milestone')),
            TrackingCard(icon:const Icon(Icons.scale, size: 40), name:'Growth',
                hoursAgo: '3 hours ago', pageFunc: () => context.go('/notes/growth')),
            TrackingCard(icon:const Icon(Icons.settings, size: 40), name:"Orginization",
               hoursAgo: "2 months ago", pageFunc:  () => context.go('/notes/organization')),
          ],
        ),
        ),
      ),
    );
    // );
  }
}
