import 'package:flutter/material.dart';

ButtonStyle blueButton(context) {
  return ButtonStyle(
    backgroundColor:
        MaterialStateProperty.all(Theme.of(context).colorScheme.tertiary),
    foregroundColor:
        MaterialStateProperty.all(Theme.of(context).colorScheme.onTertiary),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
  );
}
