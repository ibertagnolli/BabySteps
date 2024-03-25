import 'package:cloud_firestore/cloud_firestore.dart';

//Contains the database methods to access diaper information
class SocialDatabaseMethods {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Object?>> getStream(String userDoc) {
    return db
        .collection("Users")
        .doc(userDoc)
        .collection("Social")
        .orderBy('date', descending: true)
        .snapshots();
  }

  Future<DocumentReference> addPost(
      Map<String, dynamic> userInfoMap, String userDoc) async {
    return await db
        .collection('Users')
        .doc(userDoc)
        .collection('Social')
        .add(userInfoMap);
  }
}
