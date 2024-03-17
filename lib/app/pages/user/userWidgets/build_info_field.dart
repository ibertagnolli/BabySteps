import 'package:babysteps/app/pages/user/userWidgets/build_info_line.dart';
import 'package:flutter/material.dart';

class BuildInfoField extends StatelessWidget {
  const BuildInfoField(
      this.label, this.valueList, this.icon, this.editing, this.onChange,
      {super.key, this.date = false, this.id});
  final String label;
  final List<String> valueList;
  final Icon icon;
  final bool editing;
  final bool date;
  final Function(String? babyId, String newVal) onChange;
  final String? id;


  @override
  Widget build(BuildContext context) {
    List<Widget> values = List.empty(growable: true);
 
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = screenWidth * 0.85;

   
    for (String val in valueList) {
      values.add(BuildInfoLine(
        editing,
        val,
        label,
        date: date,
        onChange,
        babyId: id,
      ));
    }
    return Row( 
        children: [
          icon,
          const SizedBox(width: 16),
          Expanded(
          child:Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              '$label:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
              ...values
          ])
          ),
        ],
    );
  }
}