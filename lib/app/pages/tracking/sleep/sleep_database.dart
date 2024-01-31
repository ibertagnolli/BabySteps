import 'package:babysteps/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

//This contains all of the methods needed for sleep
class SleepDatabaseMethods {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final SharedPreferences? prefs = getPreferences();

  // Sets up the snapshot to listen to changes in the collection.
  void listenForSleepReads() {
    String? babyDoc = prefs?.getString('babyDoc');

    final docRef = db
        .collection("Babies")
        .doc(babyDoc ?? "IYyV2hqR7omIgeA4r7zQ")
        .collection("Sleep");
    docRef.snapshots().listen(
          (event) => print(
              "current data: ${event.size}"), // These are helpful for debugging, but we can remove them
          onError: (error) => print("Listen failed: $error"),
        );
  }

  // Returns a snapshot of the most recently added Weight entry
  Stream<QuerySnapshot> getStream() {
    String? babyDoc = prefs?.getString('babyDoc');

    return db
        .collection("Babies")
        .doc(babyDoc ?? "IYyV2hqR7omIgeA4r7zQ")
        .collection("Sleep")
        .orderBy('date', descending: true)
        .limit(1)
        .snapshots();
  }

  //Adds a sleep entry into the sleep collection
  Future addSleepEntry(Map<String, dynamic> userInfoMap) async {
    String? babyDoc = prefs?.getString('babyDoc');

    return await db
        .collection('Babies')
        .doc(babyDoc ??
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Sleep')
        .add(userInfoMap);
  }

  // TODO: can both of these queries return with limit(1)?
  //This method gets the entries from the sleep collection and orders them so the most recent entry
  //where the timer is no longer active is document[0].
  Future<QuerySnapshot> getLatestFinishedSleepEntry() async {
    String? babyDoc = prefs?.getString('babyDoc');

    return await db
        .collection('Babies')
        .doc(babyDoc ??
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Sleep')
        .where('active', isEqualTo: false)
        .orderBy('date', descending: true)
        .get();
  }

  //This method gets the entries from the sleep collection and orders them so the most recent entry
  //where the timer is active is document[0].
  Future<QuerySnapshot> getLatestOngoingSleepEntry() async {
    String? babyDoc = prefs?.getString('babyDoc');

    return await db
        .collection('Babies')
        .doc(babyDoc ??
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Sleep')
        .where('active', isEqualTo: true)
        .orderBy('date', descending: true)
        .get();
  }

  //This method updates the sleep entry so that the length now matches the time elapsed on the timer
  //it also updates the time ended to be the current time
  Future updateSleepEntry(
      String napLength, DateTime timeEnded, String id) async {
    String? babyDoc = prefs?.getString('babyDoc');

    return await db
        .collection("Babies")
        .doc(babyDoc ?? 'IYyV2hqR7omIgeA4r7zQ')
        .collection('Sleep')
        .doc(id)
        .update({"length": napLength, "date": timeEnded, "active": false});
  }
}
