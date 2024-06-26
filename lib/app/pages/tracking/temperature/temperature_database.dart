import 'package:cloud_firestore/cloud_firestore.dart';

//Contains the database methods to access temperature information
class TemperatureDatabaseMethods {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getStream(String babyDoc) {
    return db
        .collection("Babies")
        .doc(babyDoc)
        .collection("Temperature")
        .orderBy('date', descending: true)
        .limit(1)
        .snapshots();
  }

  //This methods adds an entry to the temperature collection
  Future addTemperature(
      Map<String, dynamic> userInfoMap, String babyDoc) async {
    return await FirebaseFirestore.instance
        .collection('Babies')
        .doc(babyDoc)
        .collection('Temperature')
        .add(userInfoMap);
  }

  //This method gets the entries from the temperature collection and orders them so the most recent entry is document[0].
  Future<QuerySnapshot> getLatestTemperatureInfo(String babyDoc) async {
    return await FirebaseFirestore.instance
        .collection('Babies')
        .doc(babyDoc)
        .collection('Temperature')
        .orderBy('date', descending: true)
        .get();
  }

  // Deletes the temperature entry identified by docId
  Future deleteTemperature(var docId, String babyDoc) async {
    return await db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Temperature')
        .doc(docId)
        .delete()
        .then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error deleting document $e"),
        );
  }
}
