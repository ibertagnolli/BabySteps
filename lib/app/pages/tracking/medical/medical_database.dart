import 'package:cloud_firestore/cloud_firestore.dart';

//Contains the database methods to access temperature information
class MedicalDatabaseMethods{
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

  // This methods adds an entry to the vaccine collection
  Future addVaccine(Map<String, dynamic> userInfoMap, String babyDoc) async {
    return await db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Vaccines')
        .add(userInfoMap);
  }

  //This method gets the entries from the temperature collection and orders them so the most recent entry is document[0].
  Stream<QuerySnapshot> getVaccineStream(String babyDoc) {
    return FirebaseFirestore.instance
        .collection('Babies')
        .doc(babyDoc)
        .collection('Vaccines')
        .orderBy('date', descending: true)
        .snapshots();
  }
}
