import 'package:babysteps/time_since.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FilledCard extends StatelessWidget {
  const FilledCard(this.timeSince, this.lastThing, this.lastIcon, {super.key});

  final String timeSince;
  final String lastThing;
  final Icon lastIcon;

  @override
  Widget build(BuildContext context) {
    //screenWidth and screenHeight is for fixing overflow errors
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
              Padding(padding: EdgeInsets.all(16), child: icon),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
        // Returns the FilledCard with read values for date, pounds, and ounces
        // updated in real time.
        return TrackingCard(icon, name, timeSinceChange, goString);
      },
    );
  }
}

class HistoryDropdown extends StatelessWidget {
  HistoryDropdown(this.recentStream, {super.key});

  var recentStream;

  @override
  Widget build(BuildContext context) {
    return Padding(
              padding: const EdgeInsets.all(15),
              child: ExpansionTile(
                backgroundColor: Theme.of(context).colorScheme.surface,
                collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
                title: Text('History',
                      style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold)),
                initiallyExpanded: false,
                children: <Widget>[
                  SizedBox(
                    height: 300, // TODO edit this to be sized based on space, not set value
                    child: HistoryTabs(recentStream)
                  ),
                ],
              ),
            );
  }
}


// sources: https://docs.flutter.dev/cookbook/design/tabs
// https://www.flutterbeads.com/change-tab-bar-color-in-flutter/
class HistoryTabs extends StatelessWidget {
  HistoryTabs(this.recentStream, {super.key});

  var recentStream;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2, // Number of tabs 
        child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize( // Need this to let us set colors for some reason 
              preferredSize: Size.fromHeight(0), // Size 0 gets rid of the gap between the top and the tabs
              child: Material(
                color: Theme.of(context).colorScheme.primary, 
                
                // Tab bar
                child: TabBar(
                  indicatorColor: Theme.of(context).colorScheme.secondary, // Color of selected tab
                  labelColor: Theme.of(context).colorScheme.onPrimary,
                  tabs: [
                    Tab(text: 'This week'),
                    Tab(text: 'All-time'),
                  ],
                ),
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),

          // The stuff displayed when the tab is selected
          body: TabBarView( 
            children: [
              // Goes in order - first goes with first tab, second with second
              recentStream,
              Icon(Icons.directions_transit),
            ],
          ),
        ),
      ),
    );
  }
}
