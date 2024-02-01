import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
        .collection('Users')
        .doc('2hUD5VwWZHXWRX3mJZOp')
        .collection('Tasks');
          docRef.snapshots().listen(
          (event) => print(
              "current data: ${event.size}"), // These are helpful for debugging, but we can remove them
          onError: (error) => print("Listen failed: $error"),
        );
  }

  // Returns a snapshot of all the user's Notes
  Stream<QuerySnapshot> getNoteStream(DateTime selectedDate) {
    return db
        .collection('Users')
        .doc('2hUD5VwWZHXWRX3mJZOp')
        .collection("Tasks")
        .where('dateTime', isEqualTo: Timestamp.fromDate(DateUtils.dateOnly(selectedDate)))
        .snapshots();
  }

  // Updates a Note
  Future updateNote(var docId, Map<String, dynamic> updatedUserInfoMap) async {
    return await db
        .collection('Users')
        .doc('2hUD5VwWZHXWRX3mJZOp') // TODO update to current user's document id
        .collection('Tasks')
        .doc(docId)
        .set(updatedUserInfoMap);
  }
}
