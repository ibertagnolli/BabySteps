import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'dart:core';

class SleepPage extends StatefulWidget {
  const SleepPage({super.key});

  @override
  State<SleepPage> createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  //final stopWatch = Stopwatch();
  String timerData = "00:00:00";
  String buttonText = "Start Nap";
  String timeSinceNap = "4:38";
  String lastNap = "0:55";

  void napClicked() {
    setState(() {
      // timerData = stopWatch.elapsedMilliseconds;
      // print(stopWatch.elapsedMilliseconds); // 0
      // stopWatch.start();
      timerData = "00:00:01";
      buttonText = "Stop Nap";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep',
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text('Tracking',
              style: TextStyle(fontSize: 36, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          backgroundColor: Theme.of(context).colorScheme.surface,
          leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        body: Center(
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.all(32),
              child: Text('Sleep',
                  style: TextStyle(fontSize: 36, color: Theme.of(context).colorScheme.onBackground)),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: FilledCard("last nap: $timeSinceNap", "nap: $lastNap",
                  Icon(Icons.person_search_sharp)),
            ),
            Text("$timerData",
                style: TextStyle(fontSize: 30, color: Theme.of(context).colorScheme.onBackground)),
            Padding(
              padding: EdgeInsets.all(32),
              child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.secondary, // Background color
                  ),
                  onPressed: napClicked,
                  child: Text("$buttonText",
                      style: TextStyle(
                          fontSize: 20, color: Theme.of(context).colorScheme.onSecondary))),
            ),
          ]),
        ),
      ),
    );
  }
}

// class FilledCard extends StatelessWidget {
//   const FilledCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const SizedBox(
//       height: 180,
//       child: Card(
//         elevation: 0,
//         color: Color(0xFFFFFAF1),
//         child: SizedBox(
//           width: 300,
//           height: 100,
//           child: Column(children: <Widget>[
//             ListTile(
//               title: Text('Time Since Last Nap: 1:28'),
//               // tileColor: ,
//             ),
//             Divider(height: 0),
//             ListTile(
//               title: Text('Last Nap Length: 00:55'),
//               // tileColor: ,
//             ),
//             Divider(height: 0),
//             ListTile(
//               title: Text('Notes'),
//               // tileColor: ,
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
// }
