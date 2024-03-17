import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuildInfoLine extends StatefulWidget {
  const BuildInfoLine(this.editing, this.value, this.field, this.onChange,
      {super.key, this.date = false, this.babyId});
  final bool editing;
  final String? value;
  final bool date;
  final String field;
  final Function(String? id, String newVal) onChange;
  final String? babyId;

  @override
  State<StatefulWidget> createState() => _BuildInfoLineState();
}

class _BuildInfoLineState extends State<BuildInfoLine> {
  @override
  Widget build(BuildContext context) {
    TextEditingController fieldController = TextEditingController(text: widget.value);
    double width = MediaQuery.of(context).size.width;
    return widget.editing
        ? SizedBox(
            width: width * 0.65,
            child: TextField(
                controller: fieldController,
                onChanged: (val) => widget.onChange(widget.babyId, val),
                onTap: widget.date
                    ? () async {
                        // Don't show keyboard
                        FocusScope.of(context).requestFocus(FocusNode());

                        DateTime? pickeddate = await showDatePicker(
                            context: context,
                            initialDate: widget.value != null
                                ? DateFormat.yMd().parse(widget.value!)
                                : DateTime.now(),
                            firstDate: DateTime(1980),
                            lastDate: DateTime(2101));

                        if (pickeddate != null) {
                          setState(() {
                            fieldController.text =
                                DateFormat.yMd().format(pickeddate).toString();
                          });
                        }
                      }
                    : null))
        : Text(
            //placeholder is loading until it reads from database, updates on refresh
            widget.value ?? 'Loading...',
            style: TextStyle(fontSize: 18),
            softWrap: true,
          );
  }
}