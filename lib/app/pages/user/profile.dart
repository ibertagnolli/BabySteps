import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String? name;
  final String? email;
  final String? babyName;
  final String? dateOfBirth;

  UserProfile({
    this.name,
    this.email,
    this.babyName,
    this.dateOfBirth,
  });
}



class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile? userProfile;
  String? babyName;
  String? dateOfBirth;

 

 Future<void> fetchUserInfo() async {
  if (FirebaseAuth.instance.currentUser != null) {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // Fetch user document using UID
      final userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('UID', isEqualTo: uid)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final userData = userSnapshot.docs.first.data();
        final babyId = userData['baby'];

        // Fetch baby document using babyId
        final babySnapshot = await FirebaseFirestore.instance
            .collection('Babies')
            .doc(babyId)
            .get();

        if (babySnapshot.exists) {
          final babyData = babySnapshot.data();
          babyName = babyData?['Name'];
          dateOfBirth = babyData?['DOB'];
        } else {
          print('Baby document not found for babyId: $babyId');
        }
      } else {
        print('User document not found for UID: $uid');
      }

      // Fetch user display name
      final name = FirebaseAuth.instance.currentUser!.displayName;
      final email = FirebaseAuth.instance.currentUser!.email;
      // Simulate fetching additional user information from your backend
      final userProfile = UserProfile(
        name: name,
        email: email,
        babyName: babyName ?? 'N/A',
        dateOfBirth: dateOfBirth ?? 'N/A', // Replace with actual date
      );

      // Update the UI to reflect the fetched information
      setState(() {
        this.userProfile = userProfile;
      });
    } catch (error) {
      print('Error fetching user information: $error');
    }
  }
}

 @override
  void initState() {
    super.initState();
    // Fetch user information when the page is initialized
    fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center( child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display user information
            Text(
              'Name: ${userProfile?.name ?? 'Loading...'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Email: ${userProfile?.email ?? 'Loading...'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Baby Name: ${userProfile?.babyName ?? 'Loading...'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Date of Birth: ${userProfile?.dateOfBirth?.toString() ?? 'Loading...'}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      ),
    );
  }
}


