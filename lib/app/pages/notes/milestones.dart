import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class MilestonePage extends StatefulWidget {
  const MilestonePage({super.key});

  @override
  State<StatefulWidget> createState() => _MilestonePageState();
}

class _MilestonePageState extends State<MilestonePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Notes'),
          leading: BackButton(
            color: Theme.of(context).colorScheme.onSurface,
            onPressed: () => Navigator.of(context).pop(),
          )),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Text("Milestones",
                    style: TextStyle(
                        fontSize: 36,
                        color: Theme.of(context).colorScheme.onBackground)),
              ),
              NotesCard(
                //const Icon(Icons.medical_services, size: 40),
                "Allergens",
                "8/9/23",
                () => context.go('/notes/milestone/allergens'),
              ),
              NotesCard(
                "Food Likes/Dislikes",
                "9/4/23",
                () => context.go('/notes/milestone/food'),
              ),
              NotesCard(
                "Firsts",
                "10/18/23",
                () => context.go('/notes/milestone/firsts'),
              ),
            ],
          ),
        ),
      ),
    );
    // );
  }
}
