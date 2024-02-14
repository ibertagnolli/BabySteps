import 'package:babysteps/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Contains the database methods to access diaper information
class DiaperDatabaseMethods {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String? babyDoc = currentUser.babies[0].collectionId;

  // Sets up the snapshot to listen to changes in the collection.
  void listenForDiaperReads() {
    final docRef = db
        .collection("Babies")
        .doc(babyDoc ?? "IYyV2hqR7omIgeA4r7zQ")
        .collection("Diaper");
    docRef.snapshots().listen(
          (event) => print(
              "current data: ${event.size}"), // These are helpful for debugging, but we can remove them
          onError: (error) => print("Listen failed: $error"),
        );
  }

  Stream<QuerySnapshot> getStream() {
    return db
        .collection("Babies")
        .doc(babyDoc ?? "IYyV2hqR7omIgeA4r7zQ")
        .collection("Diaper")
        .orderBy('date', descending: true)
        .limit(1)
        .snapshots();
  }

  //This methods adds an entry to the diaper collection
  Future addDiaper(Map<String, dynamic> userInfoMap) async {
    return await db
        .collection('Babies')
        .doc(babyDoc ??
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Diaper')
        .add(userInfoMap);
  }

  //This method gets the entries from the diaper collection and orders them so the most recent entry is document[0].
  Future<QuerySnapshot> getLatestDiaperInfo() async {
    return await db
        .collection('Babies')
        .doc(babyDoc ??
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Diaper')
        .orderBy('date', descending: true)
        .get();
  }
}
