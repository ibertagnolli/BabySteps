import 'package:cloud_firestore/cloud_firestore.dart';

//Contains the database methods to access calendar/event information
class CalendarDatabaseMethods {
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Sets up the snapshot to listen to changes in the collection.
  void listenForEventReads() {
    final docRef = db
        .collection("Babies")
        .doc("IYyV2hqR7omIgeA4r7zQ")
        .collection("Calendar");
    docRef.snapshots().listen(
          (event) => print(
              "current data: ${event.size}"), // These are helpful for debugging, but we can remove them
          onError: (error) => print("Listen failed: $error"),
        );
  }

  Stream<QuerySnapshot> getStream() {
    return db
        .collection("Babies")
        .doc("IYyV2hqR7omIgeA4r7zQ")
        .collection("Calendar")
        .orderBy('date', descending: true)
        .limit(1) //not sure if this needs to change
        .snapshots();
  }

  //This methods adds an entry to the Calendar/event collection
  Future addEvent(Map<String, dynamic> userInfoMap) async {
    return await db
        .collection('Users')
        .doc('2hUD5VwWZHXWRX3mJZOp') // TODO update to current user's document id
        .collection('Calendar')
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
