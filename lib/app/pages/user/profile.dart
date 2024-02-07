import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';


//Class to store all of the fields for the user profile. 
//not sure if this is needed but it was nice for fetching data from database
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

 
//gets the user data from the database and the baby data for that specific user. 
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
        //TODO: if more than one baby grab them all.
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
          print('Baby document not found for baby: $babyId');
        }
      } else {
        print('User document not found for UID: $uid');
      }

      // Fetch user display name and email
      final name = FirebaseAuth.instance.currentUser!.displayName;
      final email = FirebaseAuth.instance.currentUser!.email;
      // Simulate fetching additional user information from backend
      final userProfile = UserProfile(
        name: name,
        email: email,
        babyName: babyName ?? 'N/A',
        dateOfBirth: dateOfBirth ?? 'N/A', 
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


  Widget buildInfoBox(String label, List<Widget> fields) {
    return Column(
   children:[ 
    Text(
            label,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ), 
    Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [ 
          SizedBox(height: 8),
          //add the inputed info fields
          ...fields,
        ],
      ),
    ),
   ],
    );
  }

//Basically input the text, icon and label for each thing listed on the profile page
Widget buildInfoField(String label, String? value, Icon icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          icon, 
          Flexible(child:
          Text(
            '$label:',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ),
          SizedBox(width: 8),
          Text(
            //placeholder is loading until it reads from database, updates on refresh
            value ?? 'Loading...',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center( 
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //container is for the placeholder profile image 
                  Container(
                    height: 120,
                    width: 120, 
                    margin: const EdgeInsets.only(top:0,bottom:20 ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow:const[ BoxShadow(
                        color: Colors.black26, 
                      offset: Offset(2,2),
                      blurRadius: 10 
                      )],
                      image:const DecorationImage(image: const AssetImage('assets/BabyStepsLogo.png')),
                    ),
                  ),
                  //create user info box and put in fields
                 buildInfoBox('', [
                  buildInfoField('Name', userProfile?.name, const Icon(Icons.account_box)),
                  buildInfoField('Email', userProfile?.email, const Icon(Icons.email)),
                   //buildInfoField('Date of Birth', userProfile?.dateOfBirth?.toString()),
              ]),
              //create children info box and put in fields
              //TODO: display multiple baby's info when caregivers have more than one
            const SizedBox(height: 16),
              buildInfoBox('Children', [
                buildInfoField('Baby Name', userProfile?.babyName, const Icon(Icons.account_box)),
                buildInfoField('Date of Birth', userProfile?.dateOfBirth?.toString(), const Icon(Icons.calendar_month_outlined)),
              //TODO: Grab Caregivers when that is in the database
              ]),
              //edit button 
                const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: () => context.go('/login/edit'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.tertiary),
                    foregroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.onTertiary),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  child: const Text('Edit',
                  style:  TextStyle(fontSize: 26) ),
                ),
        
          ],
              ),

        ), 
      ),
      ),
    );
  }
}


