import 'package:cloud_firestore/cloud_firestore.dart';

//Contains the database methods to access diaper information
class DiaperDatabaseMethods {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getStream(String babyDoc) {
    return db
        .collection("Babies")
        .doc(babyDoc)
        .collection("Diaper")
        .orderBy('date', descending: true)
        .limit(1)
        .snapshots();
  }

  //This methods adds an entry to the diaper collection
  Future addDiaper(Map<String, dynamic> userInfoMap, String babyDoc) async {
    return await db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Diaper')
        .add(userInfoMap);
  }

  //This method gets the entries from the diaper collection and orders them so the most recent entry is document[0].
  Future<QuerySnapshot> getLatestDiaperInfo(String babyDoc) async {
    return await db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Diaper')
        .orderBy('date', descending: true)
        .get();
  }

  // Deletes the diaper entry identified by docId
  Future deleteDiaper(var docId, String babyDoc) async {
    return await db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Diaper')
        .doc(docId)
        .delete()
        .then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error deleting document $e"),
        );
  }
}
