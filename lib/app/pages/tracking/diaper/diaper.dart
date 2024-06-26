import 'package:babysteps/app/pages/tracking/diaper/diaper_database.dart';
import 'package:babysteps/app/pages/tracking/diaper/diaper_stream.dart';
import 'package:babysteps/app/widgets/history_widgets.dart';
import 'package:babysteps/app/widgets/loading_widget.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class DiaperPage extends StatefulWidget {
  const DiaperPage({super.key});

  @override
  State<StatefulWidget> createState() => _DiaperPageState();
}

class _DiaperPageState extends State<DiaperPage> {
  //set initial state for cards
  String activeButton = "Pee";
  bool diaperRash = false;
  bool diarrhea = false;
  void buttonClicked(String buttonName) {
    setState(() {
      activeButton = buttonName;
    });
  }

  //Upload data to the database with existing choices
  uploadData() async {
    Map<String, dynamic> uploaddata = {
      'type': activeButton,
      'rash': diaperRash,
      'diarrhea' : diarrhea,
      'date': DateTime.now(),
    };

    await DiaperDatabaseMethods()
        .addDiaper(uploaddata, currentUser.value!.currentBaby.value!.collectionId);
    //once data has been added, update the card accordingly
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
          child: ValueListenableBuilder(
        valueListenable: currentUser,
        builder: (context, value, child) {
          if (value == null) {
            return const LoadingWidget();
          } else {
            return Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text("Diaper Change",
                        style: TextStyle(
                            fontSize: 36,
                            color: Theme.of(context).colorScheme.onBackground)),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: SizedBox(
                      child: DiaperStream(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Type:",
                            style: TextStyle(
                                fontSize: 30,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground)),
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

                  // Diaper Rash row
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text("Diaper Rash?",
                            style: TextStyle(
                            fontSize: 30,
                            color: Theme.of(context).colorScheme.onBackground,
                            )
                          ),
                        ),
                        Transform.scale(
                          scale: 1.75,
                          child: Checkbox(
                            value: diaperRash,
                            fillColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.surface),
                            checkColor:
                                Theme.of(context).colorScheme.onSurface,
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
                      ],
                    ),
                  ),

                  // Diarrhea row only appears for Poop and Mixed
                  if (activeButton != "Pee" && activeButton != "Dry")
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 200,
                              child: Text("Diarrhea?",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Theme.of(context).colorScheme.onBackground
                                  )
                              ),
                            ),
                            Transform.scale(
                              scale: 1.75,
                              child: Checkbox(
                                value: diarrhea,
                                fillColor: MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.surface),
                                checkColor:
                                    Theme.of(context).colorScheme.onSurface,
                                side: const BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    diarrhea = newValue!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                    ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      height: 75,
                      width: 185,
                      child: FilledButton.tonal(
                        onPressed: uploadData,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.tertiary),
                          foregroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.onTertiary),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: const Text("Add Diaper",
                            style: TextStyle(fontSize: 25)),
                      ),
                    ),
                  ),

                  // History card - in widgets
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: HistoryDropdown("diaper"),
                  )
                ],
              ),
            );
          }
        },
      )),
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
        width: 120, // TODO make percentage of screen size?
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
