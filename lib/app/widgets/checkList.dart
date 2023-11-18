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
  const CheckboxListTileExample(this.item1, this.item2, this.item3,
      {super.key});

  final String item1;
  final String item2;
  final String item3;

  @override
  State<CheckboxListTileExample> createState() =>
      _CheckboxListTileExampleState();
}

class _CheckboxListTileExampleState extends State<CheckboxListTileExample> {
  bool checkboxValue1 = true;
  bool checkboxValue2 = true;
  bool checkboxValue3 = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CheckboxListTile(
          value: checkboxValue1,
          onChanged: (bool? value) {
            setState(() {
              checkboxValue1 = value!;
            });
          },
          title: const Text('get groceries'), //put item 1 here
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
          title: const Text('Fold Laundry'), //put item 2 here
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
          title: const Text('Make dinner'), //put item 3 here
          // subtitle: const Text(
          //     "Longer supporting text to demonstrate how the text wraps and how setting 'CheckboxListTile.isThreeLine = true' aligns the checkbox to the top vertically with the text."),
          // isThreeLine: true,
        ),
        //const Divider(height: 0),
      ],
    );
  }
}
