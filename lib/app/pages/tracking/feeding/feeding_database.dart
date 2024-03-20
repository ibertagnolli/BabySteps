import 'package:cloud_firestore/cloud_firestore.dart';

//This contains all of the methods needed for feeding
class FeedingDatabaseMethods {
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Sets up the snapshot to listen to changes in the collection.
  void listenForFeedingReads(String babyDoc) {
    final docRef = db.collection("Babies").doc(babyDoc).collection("Feeding");
    docRef.snapshots().listen(
          (event) => print(
              "current data: ${event.size}"), // These are helpful for debugging, but we can remove them
          onError: (error) => print("Listen failed: $error"),
        );
  }

  Stream<QuerySnapshot> getFeedingStream(String babyDoc) {
    return db
        .collection("Babies")
        .doc(babyDoc)
        .collection("Feeding")
        .orderBy('date', descending: true)
        .limit(1)
        .snapshots();
  }

  Stream<QuerySnapshot> getBreastfeedingStream(String babyDoc) {
    return db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Feeding')
        .where('type', isEqualTo: 'BreastFeeding')
        .where('active', isEqualTo: false)
        .orderBy('date', descending: true)
        .limit(1)
        .snapshots();
  }

  Stream<QuerySnapshot> getBottleFeedingStream(String babyDoc) {
    return db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Feeding')
        .where('type', isEqualTo: 'Bottle')
        .where('active', isEqualTo: false)
        .orderBy('date', descending: true)
        .limit(1)
        .snapshots();
  }

  //Adds a feeding entry into the Feeding collection
  Future addFeedingEntry(
      Map<String, dynamic> userInfoMap, String babyDoc) async {
    return await db
        .collection('Babies')
        .doc(babyDoc) // TODO update to current user's document id
        .collection('Feeding')
        .add(userInfoMap);
  }

  //This method updates a feeding entry given a length and id so the total length of time is now accurate
  Future updateFeedingEntry(
      String feedingLength, String id, String babyDoc) async {
    return await db
        .collection("Babies")
        .doc(babyDoc)
        .collection('Feeding')
        .doc(id)
        .update({"length": feedingLength, "active": false});
  }

  Future updateFeedingDoneEntry(Map<String, dynamic>? sideInfo,
      int feedingLength, String id, String babyDoc) async {
    return await db
        .collection("Babies")
        .doc(babyDoc)
        .collection('Feeding')
        .doc(id)
        .update({"side": sideInfo, 'length': feedingLength, 'active': false});
  }

  Future updateFeedingPauseEntry(
      Map<String, dynamic>? sideInfo, String id, String babyDoc) async {
    return await db
        .collection("Babies")
        .doc(babyDoc)
        .collection('Feeding')
        .doc(id)
        .update({"side": sideInfo});
  }

  //This method gets the entries from the Feeding collection where the type is breastfeeding and is on the left side
  //and orders them so the most recent entry where the timer is active is document[0].
  Future<QuerySnapshot> getLatestOngoingBreastFeedingEntry(
      String babyDoc) async {
    return await db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Feeding')
        .where('type', isEqualTo: 'BreastFeeding')
        .where('active', isEqualTo: true)
        .orderBy('date', descending: true)
        .get();
  }
}
