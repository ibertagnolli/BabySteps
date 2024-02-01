import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Contains the database methods to access Calendar information
class CalendarDatabaseMethods {
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Adds an event to the Events collection
  Future addEvent(Map<String, dynamic> userInfoMap) async {
    return await db
        .collection('Users')
        .doc('2hUD5VwWZHXWRX3mJZOp') // TODO update to current user's document id
        .collection('Events')
        .add(userInfoMap);
  }

  // Sets up the snapshot to listen to changes in the Events collection.
  void listenForEventReads() {
    final docRef = db
        .collection('Users')
        .doc('2hUD5VwWZHXWRX3mJZOp')
        .collection('Events');
          docRef.snapshots().listen(
          (event) => print(
              "current data: ${event.size}"), // These are helpful for debugging, but we can remove them
          onError: (error) => print("Listen failed: $error"),
        );
  }

  // Returns a snapshot of all the Events on selectedDate
  Stream<QuerySnapshot> getEventStream(DateTime selectedDate) {
    DateTime nextDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1);

    return db
        .collection('Users')
        .doc('2hUD5VwWZHXWRX3mJZOp')
        .collection("Events")
        // This range gets the events happening on selectedDate from 00:00-23:59
        .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(selectedDate))
        .where('dateTime', isLessThan: Timestamp.fromDate(nextDay))
        .snapshots();
  }

  // Adds a task to the Tasks collection
  Future addTask(Map<String, dynamic> userInfoMap) async {
    return await db
        .collection('Users')
        .doc('2hUD5VwWZHXWRX3mJZOp') // TODO update to current user's document id
        .collection('Tasks')
        .add(userInfoMap);
  }

  // Sets up the snapshot to listen to changes in the Tasks collection.
  void listenForTaskReads() {
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

  // Returns a snapshot of all the Tasks on selectedDate
  Stream<QuerySnapshot> getTaskStream(DateTime selectedDate) {
    return db
        .collection('Users')
        .doc('2hUD5VwWZHXWRX3mJZOp')
        .collection("Tasks")
        .where('dateTime', isEqualTo: Timestamp.fromDate(DateUtils.dateOnly(selectedDate)))
        .snapshots();
  }

  // Marks a task as completed/uncompleted
  Future updateTask(var docId, Map<String, dynamic> updatedUserInfoMap) async {
    return await db
        .collection('Users')
        .doc('2hUD5VwWZHXWRX3mJZOp') // TODO update to current user's document id
        .collection('Tasks')
        .doc(docId)
        .set(updatedUserInfoMap);
  }
}
