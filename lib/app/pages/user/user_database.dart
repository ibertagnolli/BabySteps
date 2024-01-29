import 'package:cloud_firestore/cloud_firestore.dart';

//Contains the database methods to access diaper information
class UserDatabaseMethods {
  //This methods adds an entry to the diaper collection
  Future addBaby(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection('Babies')
        .add(userInfoMap);
  }

  Future addBabyToUser(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .add(userInfoMap);
  }

  Future<QuerySnapshot> getUser(String uid) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .where('UID', isEqualTo: uid)
        .get();
  }

  Future getBaby(String babyId) async {
    return await FirebaseFirestore.instance
        .collection('Babies')
        .doc(babyId)
        .get();
  }
}
