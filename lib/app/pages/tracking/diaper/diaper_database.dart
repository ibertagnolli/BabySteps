import 'package:cloud_firestore/cloud_firestore.dart';

//Contains the database methods to access diaper information
class DiaperDatabaseMethods {
  //This methods adds an entry to the diaper collection
  Future addDiaper(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection('Babies')
        .doc(
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Diaper')
        .add(userInfoMap);
  }

  //This method gets the entries from the diaper collection and orders them so the most recent entry is document[0].
  Future<QuerySnapshot> getLatestDiaperInfo() async {
    return await FirebaseFirestore.instance
        .collection('Babies')
        .doc(
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Diaper')
        .orderBy('date', descending: true)
        .get();
  }
}
