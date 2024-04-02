import 'package:flutter/material.dart';

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
      color: theme.colorScheme.primary,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minWidth: width, maxWidth: width, minHeight: 140),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: ListTile(
                leading: Icon(Icons.access_alarm,
                    size: 50, color: theme.colorScheme.onPrimary),
                // TODO: Is it more useful to know time since last bottle/breastfed specifically or last overall feed?
                title: Text(
                  'Time since last fed: $timeSince',  
                  style: TextStyle(
                    fontSize: 20,
                    color: theme.colorScheme.onPrimary,
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
                      color: theme.colorScheme.onPrimary,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}