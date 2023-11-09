import 'package:flutter/material.dart';

class SleepPage extends StatelessWidget {
  const SleepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sleep Page'),
        ),
        body:  Center(
        child: Column(
          children: <Widget>[
          const Text('Sleep'),
          const FilledCard(),
          const Text('0:00'),
         FilledButton(
                   onPressed: () {
                    const Text("0:01");
                  } ,
                  child: const Text('Start Nap'),
                ),
          
        ]),
      ),
      ),
    );

  }
}

class FilledCard extends StatelessWidget {
  const FilledCard({super.key});

  @override
  Widget build(BuildContext context) {
    return 
    SizedBox(
      height: 180,
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.primary,
        child: const SizedBox(
          width: 300,
          height: 100,
          child: Column(children: <Widget>[
           ListTile(
            title: Text('Time Since Last Nap: 1:28'),
           // tileColor: ,
    ),
     Divider(height: 0),
      ListTile(
            title: Text('Last Nap Length: 0:55'),
           // tileColor: ,
    ),
      Divider(height: 0),
      ListTile(
            title: Text('Notes'),
           // tileColor: ,
    ),
          ]),
        ),
      ),
  
    );
  }
}


 void napClicked() {
   const Text("0:01");
           
  }
