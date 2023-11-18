import 'package:flutter/material.dart';
import 'package:babysteps/app/pages/tracking/feeding/bottleFeeding.dart';
import 'package:babysteps/app/pages/tracking/feeding/breastFeeding.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'dart:core';

class FeedingPage extends StatefulWidget {
  const FeedingPage({super.key});

  @override
  State<FeedingPage> createState() => _FeedingPageState();
}
  
class _FeedingPageState extends State<FeedingPage> {
  
  String lastTimeFed = "8:20";
  String lastFeedingType = "bottle";
  String lastBreastSide = "right";
  String lastBottleAmount = "8oz";
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feeding',
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background, 
        appBar: AppBar(
          title: Text('Tracking',
              style: TextStyle(fontSize: 36, color: Theme.of(context).colorScheme.onSurfaceVariant,)),
          backgroundColor: Theme.of(context).colorScheme.surface, 
        ),
        body: Center(
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.all(32),
              child: Text('Feeding',
                  style: TextStyle(fontSize: 36, color: Theme.of(context).colorScheme.onBackground)),
            ),

            // Top card with data
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: FilledCard("last fed: $lastTimeFed",
                      "type: $lastFeedingType", Icon(Icons.edit)),
            ),

            // Feeding options - breast feeding or bottle feeding
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: FeedingOptionCard(
                      Icon(Icons.water_drop, size: 40, color: Theme.of(context).colorScheme.onSecondary), "Breast feeding", "Last side: $lastBreastSide", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const BreastFeedingPage();
                            },
                          ),
                        );
                      }, 
                      Theme.of(context)),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: 
              FeedingOptionCard(
                      Icon(Icons.local_drink, size: 40, color: Theme.of(context).colorScheme.onSecondary), "Bottle feeding", "Last amount: $lastBottleAmount", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const BottleFeedingPage();
                            },
                          ),
                        );
                      },
                      Theme.of(context)),
            ),
          ]),
        ),
      ),
    );
  }
}

// Same as TrackingCard widget but different colors 
class FeedingOptionCard extends StatelessWidget {
  const FeedingOptionCard(this.icon, this.name, this.extraInfo, this.pageFunc, this.theme,
      {super.key});
  final Icon icon;
  final String name;
  final String extraInfo;
  final void Function() pageFunc;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: theme.colorScheme.secondary, 
      child: InkWell(
        splashColor: theme.colorScheme.secondary, 
        onTap: pageFunc,
        child: SizedBox(
          width: 360,
          height: 80,
          child: Row(
            children: [
              Padding(padding: EdgeInsets.all(16), child: icon),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSecondary,),
                    ),
                    Text(
                      extraInfo,
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.onSecondary,),
                    ),
                  ],
                ),
              ),
              Expanded(child: SizedBox()),
              Padding(
                padding: EdgeInsets.all(16),
                child: Align(
                    child: Icon(Icons.arrow_circle_right_outlined, size: 30, color: theme.colorScheme.onSecondary)),
              )
            ],
          ),
        ),
      ),
    );
  }
}