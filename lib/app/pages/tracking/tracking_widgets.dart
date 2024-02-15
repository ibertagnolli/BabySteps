import 'package:babysteps/time_since.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Card that leads to each tracking page
class TrackingCard extends StatelessWidget {
  const TrackingCard(this.icon, this.name, this.hoursAgo, this.goString,
      {super.key});
  final Icon icon;
  final String name;
  final String hoursAgo;
  final String goString;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        splashColor: Theme.of(context).colorScheme.surface,
        onTap: () => context.go(goString),
        child: SizedBox(
          width: 360,
          height: 80,
          child: Row(
            children: [
              Padding(padding: const EdgeInsets.all(16), child: icon),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style:
                          const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      hoursAgo,
                    ),
                  ],
                ),
              ),
              const Expanded(child: SizedBox()),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Align(
                    child: Icon(Icons.arrow_circle_right_outlined, size: 30)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// Queries the database for the time since last tracking metric was recorded.
class TrackingStream extends StatelessWidget {
  const TrackingStream(this.icon, this.name, this.goString,
      {super.key, required this.stream});
  final Icon icon;
  final String name;
  final String goString;
  final Stream<QuerySnapshot> stream;
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // An array of documents, but our query only returns an array of one document
        var lastDoc = snapshot.data!.docs;
        String timeSinceChange = 'Never';
        if (lastDoc.isNotEmpty) {
          DateTime date = lastDoc[0]['date'].toDate();
          timeSinceChange = getTimeSince(date, ago: true);
        }
        // Returns the TrackingCard with read values for date, pounds, and ounces
        // updated in real time.
        return TrackingCard(icon, name, timeSinceChange, goString);
      },
    );
  }
}

