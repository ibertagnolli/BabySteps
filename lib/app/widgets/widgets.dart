import 'package:flutter/material.dart';

class FilledCard extends StatelessWidget {
  const FilledCard(this.timeSince, this.lastThing, this.lastIcon, {super.key});

  final String timeSince;
  final String lastThing;
  final Icon lastIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 380,
      child: Card(
        elevation: 0,
        //color: Theme.of(context).colorScheme.primary,
        color: const Color(0xFFFFFAF1),
        child: SizedBox(
          width: 380,
          height: 180,
          child: Column(children: <Widget>[
            ListTile(
              leading: const Icon(Icons.access_alarm),
              title: Text('Time Since $timeSince',
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

class TrackingCard extends StatelessWidget {
  const TrackingCard(this.icon, this.name, this.hoursAgo, this.pageFunc,
      {super.key});
  final Icon icon;
  final String name;
  final String hoursAgo;
  final void Function() pageFunc;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xfffffaf1),
      child: InkWell(
        splashColor: const Color(0xfffffaf1),
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
