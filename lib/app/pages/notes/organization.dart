import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class OrganizationPage extends StatefulWidget {
  const OrganizationPage({super.key});

  @override
  State<StatefulWidget> createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {
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
                child: Text("Organization",
                    style: TextStyle(
                        fontSize: 36,
                        color: Theme.of(context).colorScheme.onBackground)),
              ),
              NotesCard(
                //const Icon(Icons.medical_services, size: 40),
                "Shopping List",
                "10/19/23",
                () => context.go('/notes/organization/shopping'),
              ),
              NotesCard(
                "Nap Time To Do",
                "10/21/23",
                () => context.go('/notes/organization/todo'),
              ),
            ],
          ),
        ),
      ),
    );
    // );
  }
}
