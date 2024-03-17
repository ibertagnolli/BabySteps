import 'package:cloud_firestore/cloud_firestore.dart';

//Contains the database methods to access diaper information
class UserDatabaseMethods {
  FirebaseFirestore db = FirebaseFirestore.instance;

  /// Creates a new baby
  Future addBaby(Map<String, dynamic> userInfoMap) async {
    return await db.collection('Babies').add(userInfoMap);
  }

  /// Creates a new user with an existing baby in its baby array
  Future addBabyToNewUser(Map<String, dynamic> userInfoMap) async {
    return await db.collection('Users').add(userInfoMap);
  }

  /// Returns the user with uid
  Future<QuerySnapshot> getUser(String uid) async {
    return await db.collection('Users').where('UID', isEqualTo: uid).get();
  }

  /// Returns the baby with babyId
  Future getBaby(String babyId) async {
    return await db.collection('Babies').doc(babyId).get();
  }

  Future updateBaby(String currBabyDoc, String name, DateTime date) async {
    return await db
        .collection("Babies")
        .doc(currBabyDoc)
        .update({"Name": name, "DOB": date});
  }

  /// Updates the baby at currBabyDoc with the list of caregivers
  Future updateBabyCaregiver(String currBabyDoc, List<dynamic> caregivers) async {
    return await db
        .collection("Babies")
        .doc(currBabyDoc)
        .update({"Caregivers": caregivers});
  }

  Future updateUserBabies(String userDoc, List<String> babies) async {
    return await db.collection("Users").doc(userDoc).update({"baby": babies});
  }
}
