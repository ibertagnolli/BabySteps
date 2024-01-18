import 'package:flutter/material.dart';

//void main() => runApp(const CheckboxListTileApp());

// class CheckboxListTileApp extends StatelessWidget {
//   const CheckboxListTileApp(this.item1, this.item2, this.item3, {super.key});

//   final String item1;
//   final String item2;
//   final Icon item3;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(useMaterial3: true),
//       home: const CheckboxListTileExample(item1,item2,item3),
//     );
//   }
// }

class CheckboxListTileExample extends StatefulWidget {
  CheckboxListTileExample(this.items, {super.key});

  final List<String> items;

  @override
  State<CheckboxListTileExample> createState() =>
      _CheckboxListTileExampleState();
}

class _CheckboxListTileExampleState extends State<CheckboxListTileExample> {
  bool checkboxValue1 = false;
  bool checkboxValue2 = false;
  bool checkboxValue3 = false;

  @override
  Widget build(BuildContext context) {
    List<String> items = widget.items;
    return Column(
      children: <Widget>[
        //TODO: use a list view builder here instead of hardcoding 3 items 
        //This is causing an error right now
        // ListView.builder(
        //   // Let the ListView know how many items it needs to build.
        //   itemCount: items.length,
        //   // Provide a builder function. This is where the magic happens.
        //   // Convert each item into a widget based on the type of item it is.
        //   itemBuilder: (context, index) {
        //     final item = items[index];

        //     return CheckboxListTile(
        //       value: checkboxValue1,
        //       onChanged: (bool? value) {
        //         setState(() {
        //           checkboxValue1 = value!;
        //         });
        //       },
        //       title: Text(item), 
        //     );
        //   },
        // ),

        CheckboxListTile(
          value: checkboxValue1,
          onChanged: (bool? value) {
            setState(() {
              checkboxValue1 = value!;
            });
          },
          title: Text(items[0]), //put item 1 here
          //subtitle: const Text('Supporting text'),
        ),
        //const Divider(height: 0),
        CheckboxListTile(
          value: checkboxValue2,
          onChanged: (bool? value) {
            setState(() {
              checkboxValue2 = value!;
            });
          },
          title: Text(items[1]), //put item 2 here
          //   subtitle: const Text(
          //       'Longer supporting text to demonstrate how the text wraps and the checkbox is centered vertically with the text.'),
        ),
        // const Divider(height: 0),
        CheckboxListTile(
          value: checkboxValue3,
          onChanged: (bool? value) {
            setState(() {
              checkboxValue3 = value!;
            });
          },
          title: Text(items[2]), //put item 3 here
          // subtitle: const Text(
          //     "Longer supporting text to demonstrate how the text wraps and how setting 'CheckboxListTile.isThreeLine = true' aligns the checkbox to the top vertically with the text."),
          // isThreeLine: true,
        ),
        //const Divider(height: 0),
      ],
    );
  }
}
