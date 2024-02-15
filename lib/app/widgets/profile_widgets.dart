import 'package:babysteps/app/widgets/styles.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    TextEditingController fieldController =
        TextEditingController(text: widget.value);
    double width = MediaQuery.of(context).size.width;
    return widget.editing
        ? SizedBox(
            width: width * 0.75,
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
            style: const TextStyle(fontSize: 18),
          );
  }
}

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              '$label:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...values
          ])
        ],
      ),
    );
  }
}

class BuildInfoBox extends StatelessWidget {
  const BuildInfoBox({super.key, required this.label, required this.fields});
  final String label;
  final List<Widget> fields;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, offset: Offset(2, 2), blurRadius: 10)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              //add the inputed info fields
              ...fields,
            ],
          ),
        ),
      ],
    );
  }
}

class BabyBox extends StatelessWidget {
  const BabyBox(
    this.babyName,
    this.dateOfBirth,
    this.caregivers,
    this.editing,
    this.updateName,
    this.updateDOB,
    this.babyId, {
    super.key,
  });
  final String babyName;
  final DateTime dateOfBirth;
  final List<dynamic> caregivers;
  final bool editing;
  final Function(String? id, String newVal) updateName;
  final Function(String? id, String newVal) updateDOB;
  final String babyId;

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    List<String> caregiverNames = [];
    for (Map<String, dynamic> caregiver in caregivers) {
      if (currentUser.uid != caregiver['uid']) {
        caregiverNames.add(caregiver['name'] ?? '');
      }
    }
    return BuildInfoBox(label: '', fields: [
      BuildInfoField(
        'Baby Name',
        [babyName],
        const Icon(Icons.account_box),
        editing,
        updateName,
        id: babyId,
      ),
      BuildInfoField('Date of Birth', [DateFormat.yMd().format(dateOfBirth)],
          const Icon(Icons.calendar_month_outlined), editing, updateDOB,
          date: true, id: babyId),
      if (caregiverNames.isNotEmpty || editing)
        BuildInfoField('Caregivers', caregiverNames, const Icon(Icons.people),
            editing, (unused, unused2) => {}),
      if (editing)
        ElevatedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                      child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  "Enter the user's email and we will send them an invite\nAlternatively you can send them this code and have them add it on account creation: $babyId"),
                              TextField(
                                controller: controller,
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  //send email
                                },
                                style: blueButton(context),
                                child: const Text('Send Email Invite'),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  Clipboard.setData(
                                      ClipboardData(text: babyId));
                                  //send email
                                },
                                style: blueButton(context),
                                child: const Text('Save code to clipboard'),
                              )
                            ],
                          )));
                });
          },
          style: blueButton(context),
          child: const Text('Add Caregiver'),
        ),
    ]);
  }
}
