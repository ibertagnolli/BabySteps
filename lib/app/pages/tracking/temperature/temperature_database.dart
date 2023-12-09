import 'package:cloud_firestore/cloud_firestore.dart';

//Contains the database methods to access temperature information
class TemperatureDatabaseMethods {
  //This methods adds an entry to the temperature collection
  Future addTemperature(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection('Babies')
        .doc(
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Temperature')
        .add(userInfoMap);
  }

  //This method gets the entries from the temperature collection and orders them so the most recent entry is document[0].
  Future<QuerySnapshot> getLatestTemperatureInfo() async {
    return await FirebaseFirestore.instance
        .collection('Babies')
        .doc(
            'IYyV2hqR7omIgeA4r7zQ') // TODO update to current user's document id
        .collection('Temperature')
        .orderBy('date', descending: true)
        .get();
  }
}
