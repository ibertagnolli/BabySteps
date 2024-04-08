import 'package:flutter/material.dart';

class UserPermissionBox extends StatefulWidget {
  const UserPermissionBox(
    this.caregiverId,
    this.userName,
    this.trackingView,
    this.canPost,
    this.userDoc,
    this.onChange, {
    super.key,
  });
  final String caregiverId;
  final String userName;
  final bool trackingView;
  final bool canPost;
  final String userDoc;
  final void Function(
      String caregiverUid, bool trackingAccess, bool postingAccess) onChange;

  @override
  State<UserPermissionBox> createState() => _UserPermissionsBoxState();
}

class _UserPermissionsBoxState extends State<UserPermissionBox> {
  late bool trackingAccess;
  late bool postingAccess;

  @override
  void initState() {
    super.initState();
    trackingAccess = widget.trackingView;
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
                        onChanged: (trackingView) {
                          setState(() {
                            trackingAccess = trackingView;
                          });
                          widget.onChange(widget.caregiverId, trackingAccess,
                              postingAccess);
                        })
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
                          widget.onChange(widget.caregiverId, trackingAccess,
                              postingAccess);
                        }),
                  ],
                )
              ],
            ),
          ],
        ));
  }
}
