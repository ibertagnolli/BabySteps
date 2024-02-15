import 'package:flutter/material.dart';

// Same as TrackingCard widget but different colors - on feeding landing page
class FeedingOptionCard extends StatelessWidget {
  const FeedingOptionCard(
      this.icon, this.name, this.extraInfo, this.pageFunc, this.theme,
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
              Padding(padding: const EdgeInsets.all(16), child: icon),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSecondary,
                      ),
                    ),
                    Text(
                      extraInfo,
                      style: TextStyle(
                        color: theme.colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                    child: Icon(Icons.arrow_circle_right_outlined,
                        size: 30, color: theme.colorScheme.onSecondary)),
              )
            ],
          ),
        ),
      ),
    );
  }
}


// Smaller filled card for specific feeding pages (no notes link)
class FeedingInfoCard extends StatelessWidget {
  const FeedingInfoCard(this.timeSince, this.lastThing, this.typeOfLastThing, this.lastIcon, this.theme, {super.key});

  final String timeSince;
  final String lastThing;
  final String typeOfLastThing;
  final Icon lastIcon;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double width = screenWidth * 0.85;
    return Card(
      elevation: 0,
      color: theme.colorScheme.secondary,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minWidth: width, maxWidth: width, minHeight: 140),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: ListTile(
                leading: Icon(Icons.access_alarm,
                    size: 50, color: theme.colorScheme.onSecondary),
                // TODO: Is it more useful to know time since last bottle/breastfed specifically or last overall feed?
                title: Text(
                  'Time since last fed: $timeSince',  
                  style: TextStyle(
                    fontSize: 20,
                    color: theme.colorScheme.onSecondary,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: ListTile(
                leading: lastIcon,
                title: Text('Last $typeOfLastThing: $lastThing',
                    style: TextStyle(
                      fontSize: 20,
                      color: theme.colorScheme.onSecondary,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}