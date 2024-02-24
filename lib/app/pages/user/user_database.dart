import 'package:cloud_firestore/cloud_firestore.dart';

//Contains the database methods to access diaper information
class UserDatabaseMethods {
  FirebaseFirestore db = FirebaseFirestore.instance;

  //This methods adds an entry to the diaper collection
  Future addBaby(Map<String, dynamic> userInfoMap) async {
    return await db.collection('Babies').add(userInfoMap);
  }

  Future addBabyToUser(Map<String, dynamic> userInfoMap) async {
    return await db.collection('Users').add(userInfoMap);
  }

  Future<QuerySnapshot> getUser(String uid) async {
    return await db.collection('Users').where('UID', isEqualTo: uid).get();
  }

  Future getBaby(String babyId) async {
    return await db.collection('Babies').doc(babyId).get();
  }

  Future updateBaby(String currBabyDoc, String name, DateTime date) async {
    return await db
        .collection("Babies")
        .doc(currBabyDoc)
        .update({"Name": name, "DOB": date});
  }

  Future updateBabyCaregiver(
      String currBabyDoc, List<dynamic> caregivers) async {
    return await db
        .collection("Babies")
        .doc(currBabyDoc)
        .update({"Caregivers": caregivers});
  }

  Future updateUserBabies(String userDoc, List<String> babies) async {
    return await db
    .collection("Users")
    .doc(userDoc)
    .update({"baby": babies});
  }
}
