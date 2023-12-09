import 'package:cloud_firestore/cloud_firestore.dart';

//This contains all of the methods needed for sleep
class SleepDatabaseMethods {
  //Adds a sleep entry into the sleep collection
  Future addSleepEntry(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection('Babies')
        .doc(
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Sleep')
        .add(userInfoMap);
  }

  //This method gets the entries from the sleep collection and orders them so the most recent entry
  //where the timer is no longer active is document[0].
  Future<QuerySnapshot> getLatestFinishedSleepEntry() async {
    return await FirebaseFirestore.instance
        .collection('Babies')
        .doc(
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Sleep')
        .where('active', isEqualTo: false)
        .orderBy('date', descending: true)
        .get();
  }

  //This method gets the entries from the sleep collection and orders them so the most recent entry
  //where the timer is active is document[0].
  Future<QuerySnapshot> getLatestOngoingSleepEntry() async {
    return await FirebaseFirestore.instance
        .collection('Babies')
        .doc(
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Sleep')
        .where('active', isEqualTo: true)
        .orderBy('date', descending: true)
        .get();
  }

  //This method updates the sleep entry so that the length now matches the time elapsed on the timer
  //it also updates the time ended to be the current time
  Future updateSleepEntry(String napLength, String timeEnded, String id) async {
    return await FirebaseFirestore.instance
        .collection("Babies")
        .doc('IYyV2hqR7omIgeA4r7zQ')
        .collection('Sleep')
        .doc(id)
        .update({"length": napLength, "date": timeEnded, "active": false});
  }
}
