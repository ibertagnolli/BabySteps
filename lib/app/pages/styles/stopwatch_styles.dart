import 'package:flutter/material.dart';
import 'dart:core';

Color white = const Color(0xFFFFFAF1);
Color blue = const Color.fromARGB(255, 13, 60, 70);

Color buttonColor(bool active) {
  return active ? white : blue;
}

TextStyle buttonTextStyle(bool active) {
  return TextStyle(fontSize: 18, color: active ? blue : white);
}

TextStyle timerText() {
  return TextStyle(
    fontSize: 35.0,
    color: white,
  );
}
