import 'package:cloud_firestore/cloud_firestore.dart';

// Contains the database methods to access weight information
class WeightDatabaseMethods {
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Returns a snapshot of the most recently added Weight entry
  Stream<QuerySnapshot> getStream(String babyDoc) {
    return db
        .collection("Babies")
        .doc(babyDoc)
        .collection("Weight")
        .orderBy('date', descending: true)
        .limit(1)
        .snapshots();
  }

  // This methods adds an entry to the weight collection
  Future addWeight(Map<String, dynamic> userInfoMap, String babyDoc) async {
    return await db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Vaccine')
        .add(userInfoMap);
  }

  // This method gets the entries from the weight collection and orders them so the most recent entry is document[0].
  Future<QuerySnapshot> getLatestWeightInfo(String babyDoc) async {
    return await db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Weight')
        .orderBy('date', descending: true)
        .get();
  }
}
