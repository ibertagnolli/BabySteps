import 'package:flutter/material.dart';

class SocialOnlyWidget extends StatelessWidget {
  const SocialOnlyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          "You do not have access to this page. Contact primary caregiver of this child if you believe this is wrong.",
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}
