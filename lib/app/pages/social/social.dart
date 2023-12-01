import 'package:flutter/material.dart';
import 'dart:core';

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
        ),
        body: const Placeholder());
  }
}
