import 'package:babysteps/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Contains the database methods to access diaper information
class SocialDatabaseMethods {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final SharedPreferences? prefs = getPreferences();

  // Sets up the snapshot to listen to changes in the collection.
  void listenForSocialReads() {
    String? userDoc = prefs?.getString('userDoc');
    final docRef = db
        .collection("Users")
        .doc(userDoc ?? "cNBeV7HhHMQbQfqxOgwY")
        .collection("Social");
    docRef.snapshots().listen(
          (event) => print(
              "current data: ${event.size}"), // These are helpful for debugging, but we can remove them
          onError: (error) => print("Listen failed: $error"),
        );
  }

  Stream<QuerySnapshot<Object?>> getStream() {
    String? userDoc = prefs?.getString('userDoc');
    return db
        .collection("Users")
        .doc(userDoc ?? "cNBeV7HhHMQbQfqxOgwY")
        .collection("Social")
        .orderBy('date', descending: true)
        .snapshots();
  }

  Future<DocumentReference> addPost(Map<String, dynamic> userInfoMap) async {
    String? userDoc = prefs?.getString('userDoc');
    return await db
        .collection('Users')
        .doc(userDoc ??
            "cNBeV7HhHMQbQfqxOgwY") // TODO update to current user's document id
        .collection('Social')
        .add(userInfoMap);
  }
}
