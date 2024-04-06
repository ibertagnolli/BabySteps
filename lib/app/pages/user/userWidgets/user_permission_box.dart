import 'package:flutter/material.dart';

class UserPermissionBox extends StatefulWidget {
  UserPermissionBox(
    this.userName,
    this.socialOnly,
    this.canPost,
    this.userDoc, {
    super.key,
  });
  final String userName;
  bool socialOnly;
  bool canPost;
  final String userDoc;

  @override
  State<UserPermissionBox> createState() => _UserPermissionsBoxState();
}

class _UserPermissionsBoxState extends State<UserPermissionBox> {
  late bool trackingAccess;
  late bool postingAccess;

  @override
  void initState() {
    super.initState();
    trackingAccess = !widget.socialOnly;
    postingAccess = widget.canPost;
  }

  @override
  Widget build(BuildContext context) {
    return Card.filled(
        color: Theme.of(context).cardColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: Text(
                widget.userName,
                style: const TextStyle(fontSize: 22),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Text(
                      "Access child's data",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                        thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return const Icon(Icons.check_outlined);
                          }
                          return null; // All other states will use the default thumbIcon.
                        }),
                        value: trackingAccess,
                        onChanged: (viewTracking) => setState(() {
                              trackingAccess = !trackingAccess;
                            }))
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Post about child',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                        thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return const Icon(Icons.check_outlined);
                          }
                          return null; // All other states will use the default thumbIcon.
                        }),
                        value: postingAccess,
                        onChanged: (bool canPostPhotos) {
                          setState(() {
                            postingAccess = canPostPhotos;
                          });
                        }),
                  ],
                )
              ],
            ),
          ],
        ));
  }
}
