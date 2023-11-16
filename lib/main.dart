import 'package:babysteps/app/pages/tracking/sleep.dart';
import 'package:babysteps/app/pages/tracking/diaper.dart';
import 'package:babysteps/app/pages/tracking/temperature.dart';
import 'package:babysteps/app/pages/tracking/weight.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/pages/tracking/feeding/feeding.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:babysteps/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: BabyStepsTheme().themedata.colorScheme,
        fontFamily: 'Georgia',
        //scaffoldBackgroundColor: const Color(0xffb3beb6),
        useMaterial3: true,
      ),

      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.

        backgroundColor: Theme.of(context).colorScheme.background, 
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(children: [
       Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Text("Tracking Metrics",
              style: TextStyle(fontSize: 36, color: Theme.of(context).colorScheme.onBackground)),
        ),
        TrackingCard(
            Icon(Icons.local_drink, size: 40), "Feeding", "15 minutes ago", () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const FeedingPage();
              },
            ),
          );
        }),
        TrackingCard(Icon(Icons.crib, size: 40), "Sleep", "2 hours ago", () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const SleepPage();
              },
            ),
          );
        }),
        TrackingCard(
          Icon(Icons.baby_changing_station, size: 40),
          'Diaper Change',
          '3 hours ago',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const DiaperPage();
                },
              ),
            );
          },
        ),
        TrackingCard(Icon(Icons.scale, size: 40), "Weight", "2 months ago", () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const WeightPage();
              },
            ),
          );
        }),
        TrackingCard(
            Icon(Icons.thermostat, size: 40), "Temperature", "3 weeks ago", () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const TemperaturePage();
              },
            ),
          );
        }),
      ])),
    );
  }
}
