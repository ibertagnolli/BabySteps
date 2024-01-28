import 'package:cloud_firestore/cloud_firestore.dart';

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

  Stream<QuerySnapshot> getEventStream(DateTime selectedDate) {
    return db
        .collection('Users')
        .doc('2hUD5VwWZHXWRX3mJZOp')
        .collection("Events")
        .where('date', isEqualTo: selectedDate)
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






  //This method gets the entries from the Calendar/event collection and orders them so the most recent entry is document[0].
  Future<QuerySnapshot> getLatestEventInfo() async {
    return await db
        .collection('Babies')
        .doc(
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Calendar')
        .orderBy('date', descending: true)
        .get();
  }
}
