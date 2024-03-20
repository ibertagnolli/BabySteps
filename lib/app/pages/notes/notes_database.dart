import 'package:cloud_firestore/cloud_firestore.dart';

/// Contains the database methods to access Calendar information
class NoteDatabaseMethods {
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Adds a note to the Note collection
  Future addNote(Map<String, dynamic> userInfoMap, String babyDoc) async {
    return await db
        .collection('Babies')
        .doc(babyDoc) // TODO update to current user's document id
        .collection('Notes')
        .add(userInfoMap);
  }

  // Returns a snapshot of all the user's Notes
  Stream<QuerySnapshot> getNotesStream(String babyDoc) {
    // TODO maybe return in order of most recently edited?
    return db.collection('Babies').doc(babyDoc).collection("Notes").snapshots();
  }

  // Returns a snapshot of all the user's Notes
  Stream<DocumentSnapshot<Map<String, dynamic>>> getSpecificNotesStream(
      var docId, String babyDoc) {
    return db
        .collection('Babies')
        .doc(babyDoc)
        .collection("Notes")
        .doc(docId)
        .snapshots();
  }

  // Updates a Note
  Future updateNote(var docId, Map<String, dynamic> updatedUserInfoMap,
      String babyDoc) async {
    return await db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Notes')
        .doc(docId)
        .set(updatedUserInfoMap);
  }

  // Deletes the Note identified by docId
  Future deleteNote(var docId, String babyDoc) async {
    return await db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Notes')
        .doc(docId)
        .delete()
        .then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error deleting document $e"),
        );
  }
}
