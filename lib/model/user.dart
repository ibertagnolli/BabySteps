import 'package:babysteps/model/baby.dart';

class UserProfile {
  String name;
  String email;
  String uid;
  String userDoc;
  List<Baby> babies = [];

  UserProfile({
    required this.name,
    required this.email,
    required this.uid,
    required this.userDoc,
    this.babies = const [],
  });

  updateName(String name) {
    this.name = name;
  }

  updateEmail(String email) {
    this.email = email;
  }

  addBaby(Baby baby) {
    babies.add(baby);
  }
}
