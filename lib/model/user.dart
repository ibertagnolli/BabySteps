import 'package:babysteps/model/baby.dart';
import 'package:flutter/material.dart';

class UserProfile {
  String name;
  String email;
  String uid;
  String userDoc;
  ValueNotifier<Baby?> currentBaby;
  // int currBabyIndex;
  List<Baby>? babies;
  //This is a map that looks like:
  //{
  //  docId: String
  //  primaryCaregiver: bool
  //  canPost: bool
  //  caregiver: bool //True if they can have access to all of babys info
  //}
  bool trackingView; //This is true if one baby has tracking as true

  UserProfile(
      {required this.name,
      required this.email,
      required this.uid,
      required this.userDoc,
      required this.currentBaby,
      this.babies,
      this.trackingView = true});

  updateName(String name) {
    this.name = name;
  }

  updateEmail(String email) {
    this.email = email;
  }

  addBaby(Baby baby) {
    if (babies == null) {
      babies = [baby];
    } else {
      babies!.add(baby);
    }
  }
}
