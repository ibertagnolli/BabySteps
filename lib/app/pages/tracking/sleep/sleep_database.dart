import 'package:cloud_firestore/cloud_firestore.dart';

//This contains all of the methods needed for sleep
class SleepDatabaseMethods {
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Returns a snapshot of the most recently added Weight entry
  Stream<QuerySnapshot> getStream(String babyDoc) {
    return db
        .collection("Babies")
        .doc(babyDoc)
        .collection("Sleep")
        .orderBy('date', descending: true)
        .limit(1)
        .snapshots();
  }

  //Adds a sleep entry into the sleep collection
  Future addSleepEntry(Map<String, dynamic> userInfoMap, String babyDoc) async {
    return await db
        .collection('Babies')
        .doc(babyDoc) // TODO update to current user's document id
        .collection('Sleep')
        .add(userInfoMap);
  }

  // TODO: can both of these queries return with limit(1)?
  //This method gets the entries from the sleep collection and orders them so the most recent entry
  //where the timer is no longer active is document[0].
  Future<QuerySnapshot> getLatestFinishedSleepEntry(String babyDoc) async {
    return await db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Sleep')
        .where('active', isEqualTo: false)
        .orderBy('date', descending: true)
        .get();
  }

  //This method gets the entries from the sleep collection and orders them so the most recent entry
  //where the timer is active is document[0].
  Future<QuerySnapshot> getLatestOngoingSleepEntry(String babyDoc) async {
    return await db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Sleep')
        .where('active', isEqualTo: true)
        .orderBy('date', descending: true)
        .get();
  }

  //This method updates the sleep entry so that the length now matches the time elapsed on the timer
  //it also updates the time ended to be the current time
  Future updateSleepEntry(
      String napLength, DateTime timeEnded, String id, String babyDoc) async {
    return await db
        .collection("Babies")
        .doc(babyDoc)
        .collection('Sleep')
        .doc(id)
        .update({"length": napLength, "date": timeEnded, "active": false});
  }

  // Deletes the sleep entry identified by docId
  Future deleteSleep(var docId, String babyDoc) async {
    return await db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Sleep')
        .doc(docId)
        .delete()
        .then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error deleting document $e"),
        );
  }
}
