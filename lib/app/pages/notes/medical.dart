import 'package:babysteps/app/pages/notes/notes.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class MedicalPage extends StatefulWidget {
  const MedicalPage({super.key});

  @override
  State<StatefulWidget> createState() => _MedicalPageState();
}

class _MedicalPageState extends State<MedicalPage> {
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
            child: Text("Medical",
                style: TextStyle(fontSize: 36, color: Theme.of(context).colorScheme.onBackground)),
          ),
          NotesCard(
            //const Icon(Icons.medical_services, size: 40),
            "Dr.appointment questions",
            "10/3/23",
            () => context.go('/notes/medical/appointments'),
                
          ),
          NotesCard(
            "Vaccines",
            "9/28/23",
            () => context.go('/notes/medical/vaccines'),
          ),
          NotesCard(
            "Birth Stats",
            "6/12/23",
           () => context.go('/notes/medical/birthStats'),
          ),
          NotesCard(
            "History",
            "6/14/23",
             () => context.go('/notes/medical/history'),
               
          ),
        ],
      ),
    );
    // );
  }
}
