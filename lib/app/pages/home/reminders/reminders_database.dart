import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:core';

/// Contains the database methods to access reminder information
class RemindersDatabaseMethods {
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Adds an event to the Reminders collection
  Future addReminder(Map<String, dynamic> userInfoMap, String userDoc) async {
    return await db
        .collection('Users')
        .doc(userDoc) 
        .collection('Reminders')
        .add(userInfoMap);
  }

  // Returns a snapshot of all the Reminders on selectedDate
  Stream<QuerySnapshot> getRemindersStream(DateTime selectedDate, String userDoc) {
    return db
        .collection('Users')
        .doc(userDoc)
        .collection("Reminders")
        .orderBy('dateTime')
        .snapshots();
  }

  // Returns specific reminder info
  Stream<DocumentSnapshot<Map<String, dynamic>>> getSpecificReminderStream(var docId, String userDoc) {
    return db
        .collection('Users')
        .doc(userDoc)
        .collection("Reminders")
        .doc(docId)
        .snapshots();
  }

  // Marks a task as completed/uncompleted
  Future updateReminder(var docId, Map<String, dynamic> updatedUserInfoMap, String userDoc) async {
    return await db
        .collection('Users')
        .doc(userDoc)
        .collection('Reminders')
        .doc(docId)
        .set(updatedUserInfoMap);
  }

  // Deletes the reminder identified by docId
  Future deleteReminder(var docId, String userDoc) async {
    return await db
        .collection('Users')
        .doc(userDoc)
        .collection('Reminders')
        .doc(docId)
        .delete()
        .then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error deleting document $e"),
        );
  }

}