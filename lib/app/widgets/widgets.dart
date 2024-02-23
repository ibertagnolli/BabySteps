import 'package:flutter/material.dart';

class FilledCard extends StatelessWidget {
  const FilledCard(this.timeSince, this.lastThing, this.lastIcon, {super.key});

  final String timeSince;
  final String lastThing;
  final Icon lastIcon;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = screenWidth * 0.85;
    double height = screenHeight * 0.15;
    return ConstrainedBox(
      constraints:
          BoxConstraints(minHeight: height, minWidth: width, maxWidth: width),
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surface,
          child: Column(children: <Widget>[
            ListTile(
              leading: const Icon(Icons.access_alarm),
              title: Text('Time since $timeSince',
                  style: const TextStyle(fontSize: 20)),
              // tileColor: ,
            ),
            const Divider(height: 0),
            ListTile(
              leading: lastIcon,
              title:
                  Text('Last $lastThing', style: const TextStyle(fontSize: 20)),
              // tileColor: ,
            ),
          ]),
        ),
     // ),
    );
  }
}
