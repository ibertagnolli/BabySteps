import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Contains the database methods to access Calendar information
class CalendarDatabaseMethods {
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Adds an event to the Events collection
  Future addEvent(Map<String, dynamic> userInfoMap, String userDoc) async {
    return await db
        .collection('Users')
        .doc(userDoc)
        .collection('Events')
        .add(userInfoMap);
  }

  // Returns a snapshot of all the Events on selectedDate
  Stream<QuerySnapshot> getEventStream(DateTime selectedDate, String userDoc) {
    DateTime nextDay =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1);

    return db
        .collection('Users')
        .doc(userDoc)
        .collection("Events")
        // This range gets the events happening on selectedDate from 00:00-23:59
        .where('dateTime',
            isGreaterThanOrEqualTo: Timestamp.fromDate(selectedDate))
        .where('dateTime', isLessThan: Timestamp.fromDate(nextDay))
        .snapshots();
  }

  // Adds a task to the Tasks collection
  Future addTask(Map<String, dynamic> userInfoMap, String userDoc) async {
    return await db
        .collection('Users')
        .doc(userDoc)
        .collection('Tasks')
        .add(userInfoMap);
  }

  // Returns a snapshot of all the Tasks on selectedDate
  Stream<QuerySnapshot> getTaskStream(DateTime selectedDate, String userDoc) {
    return db
        .collection('Users')
        .doc(userDoc)
        .collection("Tasks")
        .where('dateTime',
            isEqualTo: Timestamp.fromDate(DateUtils.dateOnly(selectedDate)))
        .snapshots();
  }

  // Marks a task as completed/uncompleted
  Future updateTask(var docId, Map<String, dynamic> updatedUserInfoMap,
      String userDoc) async {
    return await db
        .collection('Users')
        .doc(userDoc)
        .collection('Tasks')
        .doc(docId)
        .set(updatedUserInfoMap);
  }



  // Adds a milestone to the milestones collection
  Future addMilestone(Map<String, dynamic> userInfoMap,String userDoc) async {
    return await db
        .collection('Users')
        .doc(userDoc)
        .collection('Milestones')
        .add(userInfoMap);
  }

  // Sets up the snapshot to listen to changes in the milestones collection.
  // void listenForMilestoneReads() {
  //   final docRef = db
  //       .collection('Users')
  //       .doc(userDoc)
  //       .collection('Milestones');
  //         docRef.snapshots().listen(
  //         (event) => print(
  //             "current data: ${event.size}"), // These are helpful for debugging, but we can remove them
  //         onError: (error) => print("Listen failed: $error"),
  //       );
  // }

  // Returns a snapshot of all the milestones on selectedDate
  Stream<QuerySnapshot> getMilestoneStream(DateTime selectedDate,String userDoc) {
    return db
        .collection('Users')
        .doc(userDoc)
        .collection("Milestones")
        .where('dateTime', isEqualTo: Timestamp.fromDate(DateUtils.dateOnly(selectedDate)))
        .snapshots();
  }

 


}
