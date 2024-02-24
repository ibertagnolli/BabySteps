import 'package:babysteps/app/pages/user/user_widgets/build_info_box.dart';
import 'package:babysteps/app/pages/user/user_widgets/build_info_field.dart';
import 'package:babysteps/app/widgets/styles.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Builds off BuildInfoBox specifically for a baby
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

    /// Opens alert dialog for user to edit the Caregivers List
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
                           "Alternatively, send them this code connect their account when they create it: $babyId"
                      ),
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
    }
    
    return BuildInfoBox(
      label: '', 
      fields: [
        // Baby's Name
        BuildInfoField(
          'Baby Name',
          [babyName],
          const Icon(Icons.account_box),
          editing,
          updateName,
          id: babyId,
        ),

        // Baby's DOB
        BuildInfoField(
          'Date of Birth', 
          [DateFormat.yMd().format(dateOfBirth)],
          const Icon(Icons.calendar_month_outlined), editing, updateDOB,
          date: true, id: babyId
        ),
        
        // Caregivers List
        if (caregiverNames.isNotEmpty || editing)
          BuildInfoField(
            'Caregivers', 
            caregiverNames, 
            const Icon(Icons.people),
            editing, 
            (unused, unused2) => {}
          ),
    
        // Editing Caregivers List
        if (editing)
          ElevatedButton(
            onPressed: editCaregiversList,
            style: blueButton(context),
            child: const Text('Add Caregiver'),
          ),
      ]
      );
    }
  }
