import 'package:cloud_firestore/cloud_firestore.dart';

//Contains the database methods to access diaper information
class UserDatabaseMethods {
  FirebaseFirestore db = FirebaseFirestore.instance;

  //This methods adds an entry to the diaper collection
  Future addBaby(Map<String, dynamic> userInfoMap) async {
    return await db.collection('Babies').add(userInfoMap);
  }

  /// Creates a new user connected to a baby
  Future addUserWithBaby(Map<String, dynamic> userInfoMap) async {
    return await db.collection('Users').add(userInfoMap);
  }

  /// Returns the user with uid
  Future<QuerySnapshot> getUser(String uid) async {
    return await db.collection('Users').where('UID', isEqualTo: uid).get();
  }

  /// Gets the baby recognized by babyId
  Future getBaby(String babyId) async {
    return await db.collection('Babies').doc(babyId).get();
  }

  /// Updates the baby's information to reflect User's edits
  Future updateBaby(String currBabyDoc, String name, DateTime date) async {
    return await db
        .collection("Babies")
        .doc(currBabyDoc)
        .update({"Name": name, "DOB": date});
  }

  /// Updates the baby's list of caregivers
  Future updateBabyCaregiver(String currBabyDoc, List<dynamic> caregivers) async {
    return await db
        .collection("Babies")
        .doc(currBabyDoc)
        .update({"Caregivers": caregivers});
  }

  /// Updates a User's list of babies to reflect User's edits
  Future updateUserBabies(String userDoc, List<String> babies) async {
    return await db.collection("Users").doc(userDoc).update({"baby": babies});
  }
}
