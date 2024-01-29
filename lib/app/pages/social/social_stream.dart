import 'package:babysteps/app/pages/social/social_database.dart';
import 'package:babysteps/app/widgets/social_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocialStream extends StatefulWidget {
  const SocialStream({super.key});

  @override
  State<StatefulWidget> createState() => _SocialStreamState();
}

class _SocialStreamState extends State<SocialStream> {
  final Stream<QuerySnapshot> _socialStream =
      SocialDatabaseMethods().getStream();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _socialStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        var postWidgets = List<Widget>.empty(growable: true);

        if (snapshot.data != null) {
          var posts = snapshot.data!.docs;

          for (var post in posts) {
            String userName = post['usersName'];
            DateTime date = post['date'].toDate();
            String? title = post['title'];
            String? caption = post['caption'];
            String child = post['child'];
            String? imagePath = post['image'];

            postWidgets.add(Post(
              usersName: userName,
              timeStamp: date.toIso8601String(),
              childName: child,
              title: title,
              caption: caption,
              image: imagePath,
            ));
          }
        }

        return Column(
            children: postWidgets.isNotEmpty
                ? postWidgets
                : [const Text("no posts")]);
      },
    );
  }
}
