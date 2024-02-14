import 'package:babysteps/app/pages/tracking/feeding/add_bottle_card.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/app/pages/tracking/feeding/bottle_feeding_stream.dart';
import 'package:babysteps/app/pages/tracking/history_streams.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'dart:core';

class BottleFeedingPage extends StatefulWidget {
  const BottleFeedingPage({super.key});

  @override
  State<BottleFeedingPage> createState() => _BottleFeedingPageState();
}

class _BottleFeedingPageState extends State<BottleFeedingPage> {
  String activeButton = "Breast milk";

  // Popup text window for bottle quantity
  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: Text('How much did baby eat?',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  )),
              content: Row(
                children: [
                  Expanded(
                    child: TextField(
                        keyboardType: TextInputType.number,
                        autofocus:
                            true, // Automatically enter the text field and pull up keyboard
                        decoration:
                            InputDecoration(hintText: 'Enter quantity')),
                  ),
                  Text('oz',
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant))
                ],
              ),
              actions: [
                FilledButton(
                  child: Text('Skip'),
                  onPressed: skipQuantity,
                ),
                FilledButton(
                  child: Text('Save'),
                  onPressed: saveQuantity,
                ),
              ]));

  void skipQuantity() {
    Navigator.of(context, rootNavigator: true).pop(); // Makes the popup go away
  }

  void saveQuantity() {
    // Store info in database
    Navigator.of(context, rootNavigator: true).pop(); // Makes the popup go away
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
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.all(32),
              child: Text('Bottle Feeding',
                  style: TextStyle(
                      fontSize: 36,
                      color: Theme.of(context).colorScheme.onBackground)),
            ),

            // Top card with info
           const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: BottleFeedingStream(),
            ),

            // Add Weight Card
            const Padding(
              padding: EdgeInsets.all(15),
              child: AddBottleCard(),
            ),

            // NewStopWatch(timeSince, buttonText, updateData, () => {}, 0, false)

            // History Card - in widgets
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: HistoryDropdown(SleepHistoryStream()),
            ),
          ]),
        ),
      ),
    );
  }
}

class BottleTypeButton extends StatelessWidget {
  const BottleTypeButton(this.buttonText, this.activeButton, this.onPress,
      {super.key});

  final String buttonText;
  final bool activeButton;
  final void Function(String bottleType) onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: 60,
        width: 160,
        child: FilledButton.tonal(
          onPressed: () => {onPress(buttonText)},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              return activeButton
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface;
            }),
            foregroundColor: MaterialStateProperty.resolveWith((states) {
              return Theme.of(context).colorScheme.onSurface;
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: activeButton
                      ? const BorderSide(color: Color(0x00000000))
                      : const BorderSide(color: Colors.black)),
            ),
          ),
          child: Text(buttonText, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
