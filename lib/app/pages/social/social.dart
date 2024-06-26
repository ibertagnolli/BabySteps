import 'package:babysteps/app/pages/social/social_stream.dart';
import 'package:babysteps/app/widgets/loading_widget.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'dart:core';

import 'package:go_router/go_router.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<StatefulWidget> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Social'),
          leading: const Padding(
            padding: EdgeInsets.all(8),
            child: Image(
              image: AssetImage('assets/BabyStepsLogo.png'),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () => context.goNamed('/profile',
                    queryParameters: {'lastPage': 'social'}),
                icon: const Icon(Icons.person))
          ],
        ),
        body: ValueListenableBuilder(
          valueListenable: currentUser,
          builder: (context, value, child) {
            if (value == null) {
              return const LoadingWidget();
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => context.go('/social/newPost'),
                        )),
                    const SocialStream(),
                    // ElevatedButton(onPressed:PdfCreator.createPdf(),
                    //  child: const Text("Save to PDF"))
                  ],
                ),
              );
            }
          },
        ));
  }
}
