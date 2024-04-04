import 'package:cloud_firestore/cloud_firestore.dart';

//Contains the database methods to access diaper information
class SocialDatabaseMethods {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Object?>> getStream(String babyDoc) {
    return db
        .collection("Babies")
        .doc(babyDoc)
        .collection("Social")
        .orderBy('date', descending: true)
        .snapshots();
  }

  Future<DocumentReference> addPost(
      Map<String, dynamic> babyInfoMap, String babyDoc) async {
    return await db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Social')
        .add(babyInfoMap);
  }

  Future addLikes(
      List<dynamic> likesList, String babyDoc, String postDoc) async {
    return await db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Social')
        .doc(postDoc)
        .update({'likes': likesList});
  }

  Future addComment(
      Map<String, dynamic> comment, String babyDoc, String postDoc) async {
    DocumentSnapshot snapshot = await db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Social')
        .doc(postDoc)
        .get();
    List<dynamic> comments =
        (snapshot.data() as Map<String, dynamic>)['comments'];
    comments.add(comment);
    return await db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Social')
        .doc(postDoc)
        .update({'comments': comments});
  }
}
