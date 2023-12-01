import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:babysteps/app/widgets/widgets.dart';

class DiaperPage extends StatefulWidget {
  const DiaperPage({super.key});

  @override
  State<StatefulWidget> createState() => _DiaperPageState();
}

class _DiaperPageState extends State<DiaperPage> {
  CollectionReference diaper = FirebaseFirestore.instance.collection('diaper');

  String activeButton = "Pee";
  bool diaperRash = false;
  String timeSinceChange = "4:38";
  String lastType = "Mixed";

  //Sort of code to read from the database
  // Future<void> getLastDiaper() async {
  //   DocumentSnapshot lastDiaper =
  //       await diaper.doc("fCbWbrGw5P2TaT9TcE8r").get();
  //   // var diaperMap = Map();
  //   DateTime currTime = DateTime.now();
  //   lastType = lastDiaper['type'];
  //   diaperRash = lastDiaper['rash'];
  //   timeSinceChange = lastDiaper['date'].difference(currTime);
  // }

  /// Saves a new diaper entry in the Firestore database.
  Future<void> saveNewDiaper() {
    DateTime currentDate = DateTime.now();

    // Write weight data to database
    return diaper
        .add({
          'type': activeButton,
          'rash': diaperRash,
          'date': currentDate,
          // TODO add userID
        })
        .then((value) => addDiaperClicked())
        .catchError((error) => debugPrint("diaper couldn't be added: $error"));

    // TODO show something when the date is saved (check mark?)
    // TODO prevent user from inserting the data entry multiple times -> disable the Save button?
  }

  void buttonClicked(String buttonName) {
    setState(() {
      activeButton = buttonName;
    });
  }

  void addDiaperClicked() {
    debugPrint("Diaper added");
    setState(() {
      timeSinceChange = "0:00";
      lastType = activeButton;
      diaperRash = false;
      activeButton = "Pee";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Tracking'),
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(32),
                child: Text("Diaper Change",
                    style: TextStyle(
                        fontSize: 36,
                        color: Theme.of(context).colorScheme.onBackground)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: FilledCard(
                  "last change: $timeSinceChange",
                  "type: $lastType",
                  Icon(Icons.person_search_sharp),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Type:",
                        style: TextStyle(
                            fontSize: 30,
                            color: Theme.of(context).colorScheme.onBackground)),
                    Column(
                      children: [
                        DiaperButton('Pee', activeButton.contains("Pee"),
                            buttonClicked, Theme.of(context)),
                        const Padding(padding: EdgeInsets.only(top: 16)),
                        DiaperButton('Mixed', activeButton.contains("Mixed"),
                            buttonClicked, Theme.of(context))
                      ],
                    ),
                    Column(
                      children: [
                        DiaperButton('Poop', activeButton.contains("Poop"),
                            buttonClicked, Theme.of(context)),
                        const Padding(padding: EdgeInsets.only(top: 16)),
                        DiaperButton('Dry', activeButton.contains("Dry"),
                            buttonClicked, Theme.of(context))
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text("Diaper Rash?",
                            style: TextStyle(
                                fontSize: 30,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Transform.scale(
                        scale: 1.75,
                        child: Checkbox(
                          value: diaperRash,
                          fillColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.surface),
                          checkColor: Theme.of(context).colorScheme.onSurface,
                          side: const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                          onChanged: (bool? newValue) {
                            setState(() {
                              diaperRash = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: SizedBox(
                  height: 75,
                  width: 185,
                  child: FilledButton.tonal(
                    onPressed: saveNewDiaper,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.tertiary),
                      foregroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.onTertiary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: const Text("Add Diaper",
                        style: TextStyle(fontSize: 25)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DiaperButton extends StatelessWidget {
  const DiaperButton(
      this.buttonText, this.activeButton, this.onPress, this.theme,
      {super.key});
  final String buttonText;
  final bool activeButton;
  final void Function(String diaperType) onPress;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: SizedBox(
        height: 48,
        width: 120,
        child: FilledButton.tonal(
          onPressed: () => {onPress(buttonText)},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              return activeButton
                  ? theme.colorScheme.tertiary
                  : theme.colorScheme.surface;
            }),
            foregroundColor: MaterialStateProperty.resolveWith((states) {
              return activeButton
                  ? theme.colorScheme.onTertiary
                  : theme.colorScheme.onSurface;
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          child: Text(buttonText, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
