import 'package:cloud_firestore/cloud_firestore.dart';

// Contains the database methods to access weight information
class WeightDatabaseMethods {

  FirebaseFirestore db = FirebaseFirestore.instance;

  // Sets up the snapshot to listen to changes in the collection.
  void listenForWeightReads() {
    final docRef = db.collection("Babies").doc("IYyV2hqR7omIgeA4r7zQ").collection("Weight");
    docRef.snapshots().listen(
          (event) => print("current data: ${event.size}"),    // These are helpful for debugging, but we can remove them
          onError: (error) => print("Listen failed: $error"),
        );
  }

  // Returns a snapshot of the most recently added Weight entry
  Stream<QuerySnapshot> getStream() {
    return db
        .collection("Babies")
        .doc("IYyV2hqR7omIgeA4r7zQ")
        .collection("Weight")
        .orderBy('date', descending: true)
        .limit(1)
        .snapshots();
  }

  // This methods adds an entry to the weight collection
  Future addWeight(Map<String, dynamic> userInfoMap) async {
    return await db
        .collection('Babies')
        .doc(
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Weight')
        .add(userInfoMap);
  }

  // This method gets the entries from the weight collection and orders them so the most recent entry is document[0].
  Future<QuerySnapshot> getLatestWeightInfo() async {
    return await db
        .collection('Babies')
        .doc(
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Weight')
        .orderBy('date', descending: true)
        .get();
  }
} 
