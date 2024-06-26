import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:core';

/// Contains the database methods to access reminder information
class TasksDatabaseMethods {
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Adds an event to the Reminders collection
  Future addTask(Map<String, dynamic> userInfoMap, String userDoc) async {
    return await db
        .collection('Users')
        .doc(userDoc) 
        .collection('Reminders')
        .add(userInfoMap);
  }

  // Marks a task as completed/uncompleted
  Future updateTask(var docId, Map<String, dynamic> updatedUserInfoMap, String userDoc) async {
    return await db
        .collection('Users')
        .doc(userDoc)
        .collection('Reminders')
        .doc(docId)
        .set(updatedUserInfoMap);
  }

  // Deletes the reminder identified by docId
  Future deleteTask(var docId, String userDoc) async {
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

  // Returns a snapshot of all the Reminders, oldest reminder date first 
  Stream<QuerySnapshot> getTasksStream(String userDoc, DateTime selectedDate) {
    DateTime lastTimestamp = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);
    return db
        .collection('Users')
        .doc(userDoc)
        .collection("Reminders")
        .where('dateTime',
            isGreaterThanOrEqualTo: Timestamp.fromDate(DateUtils.dateOnly(selectedDate)))
        .where('dateTime',
            isLessThanOrEqualTo: Timestamp.fromDate(lastTimestamp))
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

}