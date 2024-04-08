import 'package:babysteps/app/pages/user/userWidgets/user_permission_box.dart';
import 'package:babysteps/app/pages/user/user_database.dart';
import 'package:babysteps/main.dart';
import 'package:babysteps/model/baby.dart';
import 'package:flutter/material.dart';

class EditPermissionsPage extends StatefulWidget {
  const EditPermissionsPage(this.babyId, {super.key});
  final String babyId;

  @override
  State<EditPermissionsPage> createState() => _EditPermissionsPageState();
}

class _EditPermissionsPageState extends State<EditPermissionsPage> {
  @override
  Widget build(BuildContext context) {
    Baby? baby;
    if (currentUser.value != null && currentUser.value!.babies != null) {
      baby = currentUser.value!.babies!
          .where((baby) => baby.collectionId == widget.babyId)
          .firstOrNull;
    }
    void onChange(
        String caregiverUid, bool trackingAccess, bool postingAccess) {
      if (baby != null) {
        baby.caregivers.firstWhere(
                (caregiver) => caregiver['uid'] == caregiverUid)['canPost'] =
            postingAccess;
        baby.caregivers.firstWhere((caregiver) =>
            caregiver['uid'] == caregiverUid)['trackingView'] = trackingAccess;
        UserDatabaseMethods()
            .updateBabyCaregiver(widget.babyId, baby.caregivers);
      }
    }

    return Scaffold(
        // Navigation Bar
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Edit Permissions'),
          leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Center(
                child: Text(
                  "Permissions for: ${baby?.name ?? 'could not get baby'}",
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.surface),
                ),
              ),
            ),
            if (baby != null)
              SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    if (baby.caregivers.isNotEmpty)
                      for (dynamic user in baby.caregivers)
                        UserPermissionBox(
                            user['uid'] ?? '',
                            user['name'] ?? '',
                            user['trackingView'] ?? true,
                            user['canPost'] ?? true,
                            user['doc'] ?? '',
                            onChange),
                  ],
                ),
              ))
          ],
        ));
  }
}
