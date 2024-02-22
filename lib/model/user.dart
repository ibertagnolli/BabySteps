import 'package:babysteps/model/baby.dart';

class UserProfile {
  String? name;
  String? email;
  String? uid;
  String? userDoc;
  List<Baby> babies;

  UserProfile({
    this.name,
    this.email,
    this.uid,
    this.userDoc,
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