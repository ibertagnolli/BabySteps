import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class GrowthPage extends StatefulWidget {
  const GrowthPage({super.key});

  @override
  State<StatefulWidget> createState() => _GrowthPageState();
}

class _GrowthPageState extends State<GrowthPage> {
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
                child: Text("Growth",
                    style: TextStyle(
                        fontSize: 36,
                        color: Theme.of(context).colorScheme.onBackground)),
              ),
              NotesCard(
                //const Icon(Icons.medical_services, size: 40),
                "Weight",
                "8/9/23",
                () => context.go('/notes/growth/weight'),
              ),
              NotesCard(
                "Teeth",
                "9/4/23",
                () => context.go('/notes/growth/teeth'),
              ),
              NotesCard(
                "Height",
                "10/18/23",
                () => context.go('/notes/growth/weight'),
              ),
            ],
          ),
        ),
      ),
    );
    // );
  }
}
