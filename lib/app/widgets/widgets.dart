import 'package:flutter/material.dart';

class FilledCard extends StatelessWidget {
  const FilledCard(this.timeSince, this.lastThing, this.lastIcon, {super.key});

  final String timeSince;
  final String lastThing;
  final Icon lastIcon;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double width = screenWidth * 0.85;

    return ConstrainedBox(
      constraints:
          BoxConstraints(minHeight: 180, minWidth: width, maxWidth: width),
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surface,
        child: SizedBox(
          width: 380,
          height: 180,
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
            const Divider(height: 0),
            const ListTile(
              leading: Icon(Icons.note),
              title: Text(
                'Notes',
                style: TextStyle(fontSize: 20),
              ),
              trailing: Icon(Icons.arrow_circle_right_outlined),
              // tileColor: ,
            ),
          ]),
        ),
      ),
    );
  }
}

class NotesCard extends StatelessWidget {
  const NotesCard(this.name, this.lastEdited, this.pageFunc, {super.key});
  final String name;
  final String lastEdited;
  final void Function() pageFunc;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        splashColor: Theme.of(context).colorScheme.surface,
        onTap: pageFunc,
        child: SizedBox(
          width: 400,
          height: 80,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(
                    16), //EdgeInsets.symmetric(vertical: 12.0),
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
                      "Last edited $lastEdited",
                    ),
                  ],
                ),
              ),
              Expanded(child: SizedBox()),
              Padding(
                padding: EdgeInsets.all(16),
                child: Align(child: Icon(Icons.edit, size: 30)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TrackingCard extends StatelessWidget {
  const TrackingCard(//this.icon, this.name, this.hoursAgo, this.pageFunc,
      {super.key, required this.icon, required this.name, required this.hoursAgo, required this.pageFunc});
  final Icon icon;
  final String name;
  final String hoursAgo;
  final void Function() pageFunc;

  @override
  Widget build(BuildContext context) {
return Card(
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        splashColor: Theme.of(context).colorScheme.surface,
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
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      hoursAgo,
                    ),
                  ],
                ),
              ),
              Expanded(child: SizedBox()),
              Padding(
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
