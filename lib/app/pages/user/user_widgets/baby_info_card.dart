import 'package:babysteps/app/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// The editable widget with User's info
class BabyInfoCard extends StatefulWidget {
  const BabyInfoCard({
    super.key, 
    required this.babyName, 
    required this.babyDOB, 
    required this.babyId,
    required this.caregivers,
    required this.editing, 
    required this.formKey, 
    // required this.babyDOBController,
    // required this.babyNameController,
    // required this.caregiversController,
  });

  // True if User is in editing mode and their info can be edited
  final String babyName;
  final DateTime babyDOB;
  final String babyId;
  final List<dynamic> caregivers;
  final bool editing;
  final Key formKey;
  // final TextEditingController babyDOBController;
  // final TextEditingController babyNameController;
  // final TextEditingController caregiversController;

  @override
  State<StatefulWidget> createState() => _BabyInfoCardState();
}

/// Stores the mutable data that can change over the lifetime of the UserInfoCard.
class _BabyInfoCardState extends State<BabyInfoCard> {
  TextEditingController babyDOBController = TextEditingController();
  TextEditingController babyNameController = TextEditingController();
  TextEditingController caregiversController = TextEditingController();

// TODO EMILY implement editCaregiversList functionality
  void editCaregiversList() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Enter the user's email and we will send them an invite\n"
                          "Alternatively, send them this code connect their account when they create it: ${widget.babyId}"
                    ),
                    TextField(
                      controller: caregiversController,
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
                            ClipboardData(text: widget.babyId));
                        //send email
                      },
                      style: blueButton(context),
                      child: const Text('Save code to clipboard'),
                    )
                  ],
                )));
      });
  }

  @override
  Widget build(BuildContext context) {
    // Now that widget has the passed the User info, populate the controllers
    babyDOBController.text = DateFormat.yMd().format(widget.babyDOB).toString();
    babyNameController.text = widget.babyName;

    final screenWidth = MediaQuery.of(context).size.width;
    double textFieldWidth = screenWidth * 0.75;
  
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        // Card container
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 10)
          ],
        ),
        child: 
            Column(children: <Widget>[
            
              // Baby Name
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: 
                Column(children: <Widget>[
                  // Name Icon and Title
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(Icons.account_box), 
                      ),
                      Text(
                        "Baby's Name",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ]
                  ),
                  // Form field for editing profile mode
                  if (widget.editing)
                    SizedBox(
                      width: textFieldWidth,
                      child: TextFormField(
                        controller: babyNameController,
                        maxLength: 25,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the baby\'s name';
                          }
                          return null;
                        },
                      )
                    ),
                  // Normal text if not editing profile
                  if (!widget.editing)
                    Text(
                      babyNameController.text,
                      style: const TextStyle(fontSize: 20),
                    )
                ]),
              ),

              // DOB Icon and Title
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: 
                Column(children: <Widget>[
                  // Name Icon and Title
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(Icons.calendar_today_rounded), 
                      ),
                      Text(
                        "Baby's Date of Birth",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ]
                  ),
                  // Form field for editing profile mode
                  if (widget.editing)
                    SizedBox(
                      width: textFieldWidth,
                      child: TextFormField(
                        controller: babyDOBController,
                        onTap: () async {
                          DateTime? pickeddate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now());

                          if (pickeddate != null) {
                            setState(() {
                              // widget.babyDOBController.clear();
                              babyDOBController.text = DateFormat.yMd().format(pickeddate).toString(); // TODO controller text is updated, but its update doesn't show
                              // print("***controller text: ${widget.babyDOBController.text}");
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a date';
                          }
                          return null;
                        },
                        // Don't show the keyboard
                        showCursor: true,
                        readOnly: true,
                      )
                    ),
                  // Normal text if not editing profile
                  if (!widget.editing)
                    Text(
                      babyDOBController.text, // TODO maybe format this to ymd format
                      style: const TextStyle(fontSize: 20),
                    )
                ],),
              ),

              // Caregivers
              if (widget.caregivers.isNotEmpty || widget.editing)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: 
                  Column(children: <Widget>[
                    // Name Icon and Title
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(Icons.people), 
                        ),
                        Text(
                          "Other Caregivers",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ]
                    ),
                    // List of Caregivers
                    Text(
                      // TODO update to show caregiver names
                      "Number of caregivers: ${widget.caregivers.length}"
                    ),
                    // Form field for editing profile mode
                    ElevatedButton(
                      onPressed: editCaregiversList,
                      style: blueButton(context),
                      child: const Text('Add Caregiver'),
                    ),                          
                  ],),
                ),
            ],),
          ),
      // )
    );
  }
}
