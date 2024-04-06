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
        .collection("Medical")
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
        .collection('Medical')
        .add(userInfoMap);
  }

  // Returns all entries in the vaccine collection.
  Stream<QuerySnapshot> getVaccineStream(String babyDoc) {
    return FirebaseFirestore.instance
        .collection('Babies')
        .doc(babyDoc)
        .collection('Medical')
        .where('type', isEqualTo: 'vaccine')
        .orderBy('date', descending: true)
        .snapshots();
  }

  // Updates the Vaccine card on the Medical landing page.
  Stream<QuerySnapshot> getLatestVaccineUpdate(String babyDoc) {
    return db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Medical')
        .where('type', isEqualTo: 'vaccine')
        .orderBy('date', descending: true)
        .limit(1)
        .snapshots();
  }

  // Updates a vaccine entry in the database.
  Future updateVaccine(var docId, Map<String, dynamic> updatedUserInfoMap,
      String babyDoc) async {
    return await db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Medical')
        .doc(docId)
        .set(updatedUserInfoMap);
  }

  // MEDICATION METHODS

  // Adds an entry to the medication collection.
  Future addMedication(Map<String, dynamic> userInfoMap, String babyDoc) async {
    return await db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Medical')
        .add(userInfoMap);
  }

  // Returns 10 most recent entries in the medication collection.
  Stream<QuerySnapshot> getMedicationStream(String babyDoc) {
    return FirebaseFirestore.instance
        .collection('Babies')
        .doc(babyDoc)
        .collection('Medical')
        .where('type', isEqualTo: 'medication')
        .orderBy('date', descending: true)
        .limit(10)
        .snapshots();
  }

  // Updates the Medication card on the Medical landing page.
  Stream<QuerySnapshot> getLatestMedicationUpdate(String babyDoc) {
    return db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Medical')
        .where('type', isEqualTo: 'medication')
        .orderBy('date', descending: true)
        .limit(1)
        .snapshots();
  }

  // Updates a medication entry in the database.
  Future updateMedication(var docId, Map<String, dynamic> updatedUserInfoMap,
      String babyDoc) async {
    return await db
        .collection('Babies')
        .doc(babyDoc)
        .collection('Medical')
        .doc(docId)
        .set(updatedUserInfoMap);
  }
}
