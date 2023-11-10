import 'package:flutter/material.dart';
import 'dart:core';
import 'package:babysteps/app/widgets/widgets.dart';

class DiaperPage extends StatefulWidget {
  const DiaperPage({super.key});

  @override
  State<StatefulWidget> createState() => _DiaperPageState();
}

class _DiaperPageState extends State<DiaperPage> {
  String activeButton = "Pee";
  bool diaperRash = false;
  String timeSinceChange = "4:38";
  String lastType = "Mixed";
  void buttonClicked(String buttonName) {
    setState(() {
      activeButton = buttonName;
    });
  }

  void addDiaperClicked() {
    setState(() {
      timeSinceChange = "0:00";
      lastType = activeButton;
      diaperRash = false;
      activeButton = "Pee";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diaper Change',
      home: Scaffold(
        backgroundColor: const Color(0xffb3beb6),
        appBar: AppBar(
          title: const Text('Tracking'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(32),
                child: Text("Diaper Change",
                    style: TextStyle(fontSize: 36, color: Color(0xFFFFFAF1))),
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: FilledCard("last change: $timeSinceChange",
                      "type: $lastType", Icon(Icons.person_search_sharp))),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Type:",
                        style:
                            TextStyle(fontSize: 30, color: Color(0xFFFFFAF1))),
                    Column(
                      children: [
                        DiaperButton(
                            'Pee', activeButton.contains("Pee"), buttonClicked),
                        const Padding(padding: EdgeInsets.only(top: 16)),
                        DiaperButton('Mixed', activeButton.contains("Mixed"),
                            buttonClicked)
                      ],
                    ),
                    Column(
                      children: [
                        DiaperButton('Poop', activeButton.contains("Poop"),
                            buttonClicked),
                        const Padding(padding: EdgeInsets.only(top: 16)),
                        DiaperButton(
                            'Dry', activeButton.contains("Dry"), buttonClicked)
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
                    const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text("Diaper Rash?",
                            style: TextStyle(
                                fontSize: 30, color: Color(0xFFFFFAF1)))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Transform.scale(
                        scale: 1.75,
                        child: Checkbox(
                          value: diaperRash,
                          fillColor: MaterialStateProperty.all(
                              const Color(0xFFFFFAF1)),
                          checkColor: Colors.black,
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
                    onPressed: addDiaperClicked,
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF4F646F)),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
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
  const DiaperButton(this.buttonText, this.activeButton, this.onPress,
      {super.key});
  final String buttonText;
  final bool activeButton;
  final void Function(String diaperType) onPress;

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
                  ? const Color(0xFF4F646F)
                  : const Color(0xFFFFFAF1);
            }),
            foregroundColor: MaterialStateProperty.resolveWith((states) {
              return activeButton
                  ? const Color.fromARGB(255, 255, 255, 255)
                  : const Color.fromARGB(255, 0, 0, 0);
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
