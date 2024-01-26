import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

//This contains all of the methods needed for feeding
class FeedingDatabaseMethods {

  FirebaseFirestore db = FirebaseFirestore.instance;

  // Sets up the snapshot to listen to changes in the collection.
  void listenForFeedingReads() {
    final docRef = db.collection("Babies").doc("IYyV2hqR7omIgeA4r7zQ").collection("Feeding");
    docRef.snapshots().listen(
          (event) => print("current data: ${event.size}"),    // These are helpful for debugging, but we can remove them
          onError: (error) => print("Listen failed: $error"),
        );
  }

  //Adds a feeding entry into the Feeding collection
  Future addFeedingEntry(Map<String, dynamic> userInfoMap) async {
    return await db
        .collection('Babies')
        .doc(
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Feeding')
        .add(userInfoMap);
  }
 
  //This method gets the entries from the entire Feeding collection and orders them so the most recent entry
  //where the timer is no longer active is document[0].
  Future<QuerySnapshot> getLatestFeedingEntry() async {
    return await db
        .collection('Babies')
        .doc(
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Feeding')
        .orderBy('date', descending: true)
        .get();
  }

  //This method gets the entries from the Feeding collection where the type is breastfeeding and is on the left side
  //and orders them so the most recent entry where the timer is active is document[0].
  Future<QuerySnapshot> getLatestOngoingLeftBreastFeedingEntry() async {
    return await db
        .collection('Babies')
        .doc(
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Feeding')
        .where('type', isEqualTo: 'BreastFeeding')
        .where('active', isEqualTo: true)
        .where('side', isEqualTo: 'Left')
        .orderBy('date', descending: true)
        .get();
  }

  //This method gets the entries from the Feeding collection where the type is breastfeeding and is on the right side
  //and orders them so the most recent entry where the timer is active is document[0].
  Future<QuerySnapshot> getLatestOngoingRightBreastFeedingEntry() async {
    return await db
        .collection('Babies')
        .doc(
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Feeding')
        .where('type', isEqualTo: 'BreastFeeding')
        .where('active', isEqualTo: true)
        .where('side', isEqualTo: 'Right')
        .orderBy('date', descending: true)
        .get();
  }

  //This method gets the entries from the Feeding collection where the type is breastfeeding
  //and orders them so the most recent entry where the timer is not active is document[0].
  Future<QuerySnapshot> getLatestFinishedBreastFeedingEntry() async {
    return await db
        .collection('Babies')
        .doc(
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Feeding')
        .where('type', isEqualTo: 'BreastFeeding')
        .where('active', isEqualTo: false)
        .orderBy('date', descending: true)
        .get();
  }

  //This method gets the entries from the Feeding collection where the type is bottle feeding
  //and orders them so the most recent entry where the timer is active is document[0].
  Future<QuerySnapshot> getLatestOngoingBottleEntry() async {
    return await db
        .collection('Babies')
        .doc(
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Feeding')
        .where('type', isEqualTo: 'Bottle')
        .where('active', isEqualTo: true)
        .orderBy('date', descending: true)
        .get();
  }

  //This method gets the entries from the Feeding collection where the type is bottle feeding
  //and orders them so the most recent entry where the timer is not active is document[0].
  Future<QuerySnapshot> getLatestFinishedBottleEntry() async {
    return await db
        .collection('Babies')
        .doc(
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Feeding')
        .where('type', isEqualTo: 'Bottle')
        .where('active', isEqualTo: false)
        .orderBy('date', descending: true)
        .get();
  }

  //This method updates a feeding entry given a length and id so the total length of time is now accurate
  Future updateFeedingEntry(String feedingLength, String id) async {
    return await db
        .collection("Babies")
        .doc('IYyV2hqR7omIgeA4r7zQ')
        .collection('Feeding')
        .doc(id)
        .update({"length": feedingLength, "active": false});
  }
}
