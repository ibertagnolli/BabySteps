import 'package:cloud_firestore/cloud_firestore.dart';

//Contains the database methods to access temperature information
class MedicalDatabaseMethods{
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Updates the Medical card on the Tracking landing page.
  Stream<QuerySnapshot> getStream(String babyDoc) {
    // TODO EMILY: Compare dates from Vaccines, Condition, and Medications.
    // Return the document with the most recent date.
    return db
        .collection("Babies")
        .doc(babyDoc)
        .collection("Vaccines")
        .orderBy('date', descending: true)
        .limit(1)
        .snapshots();
  }

  // VACCINE METHODS

  // Adds an entry to the vaccine collection.
  Future addVaccine(Map<String, dynamic> userInfoMap, String babyDoc) async {
    return await db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Vaccines')
        .add(userInfoMap);
  }

  // Returns all entries in the vaccine collection.
  Stream<QuerySnapshot> getVaccineStream(String babyDoc) {
    return FirebaseFirestore.instance
        .collection('Babies')
        .doc(babyDoc)
        .collection('Vaccines')
        .orderBy('date', descending: true)
        .snapshots();
  }

  // Updates the Vaccine card on the Medical landing page.
  Stream<QuerySnapshot> getLatestVaccineUpdate(String babyDoc) {
    return db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Vaccines')
        .orderBy('date', descending: true)
        .limit(1)
        .snapshots();
  }
}
