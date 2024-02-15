import 'package:cloud_firestore/cloud_firestore.dart';

/// Contains the database methods to access Calendar information
class NoteDatabaseMethods {
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Adds a note to the Note collection
  Future addNote(Map<String, dynamic> userInfoMap) async {
    return await db
        .collection('Babies')
        .doc('IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Notes')
        .add(userInfoMap);
  }

  // Sets up the snapshot to listen to changes in the Notes collection.
  void listenForNoteReads() {
    final docRef = db
        .collection('Babies')
        .doc('IYyV2hqR7omIgeA4r7zQ')
        .collection('Notes');
          docRef.snapshots().listen(
          (event) => print(
              "current data: ${event.size}"), // These are helpful for debugging, but we can remove them
          onError: (error) => print("Listen failed: $error"),
        );
  }

  // Returns a snapshot of all the user's Notes
  Stream<QuerySnapshot> getNotesStream() {
    // TODO maybe return in order of most recently edited?
    return db
        .collection('Babies')
        .doc('IYyV2hqR7omIgeA4r7zQ')
        .collection("Notes")
        .snapshots();
  }

  // Returns a snapshot of all the user's Notes
  Stream<DocumentSnapshot<Map<String, dynamic>>> getSpecificNotesStream(var docId) {
    return db
        .collection('Babies')
        .doc('IYyV2hqR7omIgeA4r7zQ')
        .collection("Notes")
        .doc(docId)
        .snapshots();
  }

  // Updates a Note
  Future updateNote(var docId, Map<String, dynamic> updatedUserInfoMap) async {
    return await db
        .collection('Babies')
        .doc('IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Notes')
        .doc(docId)
        .set(updatedUserInfoMap);
  }

  // Deletes the Note identified by docId
  Future deleteNote(var docId) async {
    return await db
        .collection('Babies')
        .doc('IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Notes')
        .doc(docId)
        .delete()
        .then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error deleting document $e"),
        );
  }
}
