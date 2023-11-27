import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The widget that adds a weight measurement.
class AddWeightCard extends StatefulWidget {
  // AddWeightCard();
  @override
  State<StatefulWidget> createState() => _AddWeightCardState();
  
}

/// Stores the mutable data that can change over the lifetime of the AddWeightCard.
class _AddWeightCardState extends State<AddWeightCard> {

  TextEditingController date = TextEditingController();

  void saveNewWeight() {
    // TODO save new weight in the database
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      // TODO does this need a PageExpansionKey? TODO: have open by default?
      // TODO: round corners
      backgroundColor: Theme.of(context).colorScheme.surface,
      collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
      title: Text('Add Weight',
          style: TextStyle(
              fontSize: 25,
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold)),
      children: <Widget>[
        // Padding around main contents of Weight Card
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              // TODO make ListView instead? -> Will it need to scroll?

              // First row: Weight inputs
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(children: <Widget>[
                  Text('Weight:',
                      style: TextStyle(
                          fontSize: 20, color: Theme.of(context).colorScheme.onSurface)),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '13',
                        ),
                      ),
                    ),
                  ),
                  Text('lbs',
                      style: TextStyle(
                          fontSize: 20, color: Theme.of(context).colorScheme.onSurface)),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '13',
                        ),
                      ),
                    ),
                  ),
                  Text('oz',
                      style: TextStyle(
                          fontSize: 20, color: Theme.of(context).colorScheme.onSurface)),
                ]),
              ),

              // Second row: Date input
              TextField(
                  controller: date,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today_rounded),
                      labelText:
                          "Select Date" // DateFormat('dd-MM-yyyy').format(DateTime.now()) // TODO: This is the idea for default date selection, doesn't work with const
                      ),
                  onTap: () async {
                    DateTime? pickeddate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2101));

                    if (pickeddate != null) {
                      setState(() {
                        date.text = DateFormat('dd-MM-yyyy')
                            .format(pickeddate);
                      });
                    }
                  }),

              // Third row: Submit button
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: SizedBox(
                  height: 75,
                  width: 185,
                  child: FilledButton.tonal(
                    onPressed: saveNewWeight,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.tertiary),
                      foregroundColor:
                          MaterialStateProperty.all(Theme.of(context).colorScheme.onTertiary),  
                      shape: MaterialStateProperty.all<
                          RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: const Text("Save",
                        style: TextStyle(fontSize: 25)),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}