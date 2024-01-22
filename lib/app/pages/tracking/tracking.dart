import 'package:babysteps/app/pages/tracking/diaper/diaper_database.dart';
import 'package:babysteps/app/pages/tracking/feeding/feeding_database.dart';
import 'package:babysteps/app/pages/tracking/sleep/sleep_database.dart';
import 'package:babysteps/app/pages/tracking/temperature/temperature_database.dart';
import 'package:babysteps/app/pages/tracking/weight/weight_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<StatefulWidget> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  //If we don't get any information back from the database, likely the user hasn't logged any information yet (or the database is having issues)
  String lastDiaper = 'Never';
  String lastSleep = 'Never';
  String lastFeed = 'Never';
  String lastWeight = 'Never';
  String lastTemp = 'Never';

  final Stream<QuerySnapshot> _diaperStream =
      DiaperDatabaseMethods().getStream();

  getData() async {
    //Get the latest information for the fields
    QuerySnapshot sleepQuerySnapshot =
        await SleepDatabaseMethods().getLatestFinishedSleepEntry();
    QuerySnapshot feedingQuerySnapshot =
        await FeedingDatabaseMethods().getLatestFeedingEntry();
    QuerySnapshot weightQuerySnapshot =
        await WeightDatabaseMethods().getLatestWeightInfo();
    QuerySnapshot tempQuerySnapshot =
        await TemperatureDatabaseMethods().getLatestTemperatureInfo();

    if (sleepQuerySnapshot.docs.isNotEmpty) {
      try {
        String diff = DateTime.now()
            .difference(
                DateTime.parse(sleepQuerySnapshot.docs[0]['date'].toString()))
            .inMinutes
            .toString();
        lastSleep = diff == '1' ? '$diff minute ago' : '$diff minutes ago';
      } catch (error) {
        debugPrint(error.toString());
      }
    }
    if (feedingQuerySnapshot.docs.isNotEmpty) {
      try {
        String diff = DateTime.now()
            .difference(
                DateTime.parse(feedingQuerySnapshot.docs[0]['date'].toString()))
            .inMinutes
            .toString();
        lastFeed = diff == '1' ? '$diff minute ago' : '$diff minutes ago';
      } catch (error) {
        debugPrint(error.toString());
      }
    }
    if (weightQuerySnapshot.docs.isNotEmpty) {
      try {
        DateTime dt =
            (weightQuerySnapshot.docs[0]['date'] as Timestamp).toDate();
        //Get the difference in time between now and when the last logged diaper was
        String diff = DateTime.now().difference(dt).inDays.toString();
        lastWeight = diff == '1' ? '$diff day' : '$diff days';
      } catch (error) {
        debugPrint(error.toString());
      }
    }
    if (tempQuerySnapshot.docs.isNotEmpty) {
      try {
        DateTime dt = (tempQuerySnapshot.docs[0]['date'] as Timestamp).toDate();
        //Get the difference in time between now and when the last logged diaper was
        String diff = DateTime.now().difference(dt).inDays.toString();
        lastTemp = diff == '1' ? '$diff day' : '$diff days';
      } catch (error) {
        debugPrint(error.toString());
      }
    }
    setState(() {});
  }

  //Call the async reads on initialization
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Tracking'),
        leading: const Padding(
          padding: EdgeInsets.all(8),
          child: Image(
            image: AssetImage('assets/BabyStepsLogo.png'),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 32),
                child: TrackingCard(const Icon(Icons.local_drink, size: 40),
                    "Feeding", lastFeed, () => context.go('/tracking/feeding')),
              ),
              TrackingCard(const Icon(Icons.crib, size: 40), "Sleep", lastSleep,
                  () => context.go('/tracking/sleep')),
              StreamBuilder<QuerySnapshot>(
                stream: _diaperStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }

                  // An array of documents, but our query only returns an array of one document
                  var lastDiaperDoc = snapshot.data!.docs;

                  DateTime date =
                      DateTime.parse(lastDiaperDoc[0]['date'].toString());
                  String diff =
                      DateTime.now().difference(date).inMinutes.toString();
                  String timeSinceChange =
                      diff == '1' ? '$diff min' : '$diff mins';

                  // Returns the FilledCard with read values for date, pounds, and ounces
                  // updated in real time.
                  return TrackingCard(
                      const Icon(Icons.baby_changing_station, size: 40),
                      'Diaper Change',
                      timeSinceChange,
                      () => context.go('/tracking/diaper'));
                },
              ),
              TrackingCard(const Icon(Icons.scale, size: 40), "Weight",
                  lastWeight, () => context.go('/tracking/weight')),
              TrackingCard(
                  const Icon(Icons.thermostat, size: 40),
                  "Temperature",
                  lastTemp,
                  () => context.go('/tracking/temperature')),
            ],
          ),
        ),
      ),
    );
  }
}
