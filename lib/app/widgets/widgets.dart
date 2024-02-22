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
