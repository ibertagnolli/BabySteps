import 'package:cloud_firestore/cloud_firestore.dart';

//Contains the database methods to access weight information
class WeightDatabaseMethods {
  //This methods adds an entry to the weight collection
  Future addWeight(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection('Babies')
        .doc(
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Weight')
        .add(userInfoMap);
  }

  //This method gets the entries from the weight collection and orders them so the most recent entry is document[0].
  Future<QuerySnapshot> getLatestWeightInfo() async {
    return await FirebaseFirestore.instance
        .collection('Babies')
        .doc(
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Weight')
        .orderBy('date', descending: true)
        .get();
  }
}
