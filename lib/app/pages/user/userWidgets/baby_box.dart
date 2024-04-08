import 'package:babysteps/app/pages/user/userWidgets/build_info_box.dart';
import 'package:babysteps/app/pages/user/userWidgets/build_info_field.dart';
import 'package:babysteps/app/widgets/styles.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BabyBox extends StatelessWidget {
  const BabyBox(
    this.babyName,
    this.dateOfBirth,
    this.caregivers,
    this.editing,
    this.updateName,
    this.updateDOB,
    this.babyId,
    this.isPrimaryCaregiver, {
    super.key,
  });
  final String babyName;
  final DateTime dateOfBirth;
  final List<dynamic> caregivers;
  final bool editing;
  final Function(String? id, String newVal) updateName;
  final Function(String? id, String newVal) updateDOB;
  final String babyId;
  final bool isPrimaryCaregiver;

  @override
  Widget build(BuildContext context) {
    // TextEditingController controller = TextEditingController();
    List<String> caregiverNames = [];
    for (Map<String, dynamic> caregiver in caregivers) {
      if (currentUser.value!.uid != caregiver['uid']) {
        caregiverNames.add(caregiver['name'] ?? '');
      }
    }

    return BuildInfoBox(label: '', fields: [
      BuildInfoField(
        'Baby Name',
        [babyName],
        const Icon(Icons.account_box),
        editing && isPrimaryCaregiver,
        updateName,
        id: babyId,
      ),
      BuildInfoField(
          'Date of Birth',
          [DateFormat.yMd().format(dateOfBirth)],
          const Icon(Icons.calendar_month_outlined),
          editing && isPrimaryCaregiver,
          updateDOB,
          date: true,
          id: babyId),
      if (caregiverNames.isNotEmpty || (editing && isPrimaryCaregiver))
        BuildInfoField('Caregivers', caregiverNames, const Icon(Icons.people),
            false, (unused, unused2) => {}),
      if (editing && isPrimaryCaregiver)
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
                                  "Send the caregiver you want to add this code and have them add it on account creation: $babyId"),
                              // Text(
                              //     "Enter the user's email and we will send them an invite\nAlternatively you can send them this code and have them add it on account creation: $babyId"),
                              // TextField(
                              //   controller: controller,
                              // ),
                              // const SizedBox(height: 8),
                              // ElevatedButton(
                              //   onPressed: () {
                              //     //send email
                              //   },
                              //   style: blueButton(context),
                              //   child: const Text('Send Email Invite'),
                              // ),
                              // const SizedBox(height: 8),
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
      if (editing && isPrimaryCaregiver)
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
                            "Send the user this code and have them add it on account creation: ${babyId}_SOU"),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: "${babyId}_SOU"));
                            //send email
                          },
                          style: blueButton(context),
                          child: const Text('Save code to clipboard'),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
          style: blueButton(context),
          child: const Text('Add Social User'),
        ),
      if (isPrimaryCaregiver && (caregivers.isNotEmpty))
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: ElevatedButton(
            onPressed: () {
              context.goNamed('/profile/userconfig',
                  queryParameters: {'babyId': babyId});
            },
            style: blueButton(context),
            child: const Text('Edit user permissions'),
          ),
        ),
    ]);
  }
}
