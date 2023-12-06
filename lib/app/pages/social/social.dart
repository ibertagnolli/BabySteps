import 'package:babysteps/app/widgets/social_widgets.dart';
import 'package:flutter/material.dart';
import 'dart:core';

import 'package:go_router/go_router.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<StatefulWidget> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  //TODO: Remove this code once we are using real data from the database
  String usersName = "";
  String timeStamp = "";
  String childName = "";
  String? title = "";
  String? caption = "";
  String? image = '';
  bool postAdded = false;

  //TODO: remove this code as well
  void addPost(String userName, String time, String child, String? postTitle,
      String? cap, String? img) {
    setState(() {
      postAdded = true;
      usersName = userName;
      timeStamp = time;
      childName = child;
      title = postTitle;
      caption = cap;
      image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Social'),
        leading: const Padding(
          padding: EdgeInsets.all(8),
          child: Image(
            image: AssetImage('assets/BabyStepsLogo.png'),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.add),
                  //We will want to remove the 'extra' once we have data coming in from the database
                  onPressed: () =>
                      context.go('/social/newPost', extra: addPost),
                )),
            Center(
              child: Column(
                children: [
                  //All of the below posts are hardcoded, we'll want to remove those and dynamically update them later
                  if (postAdded)
                    Post(
                      usersName: usersName,
                      timeStamp: timeStamp,
                      childName: childName,
                      title: title,
                      caption: caption,
                      image: image,
                    ),
                  const Post(
                      usersName: "John Smith",
                      timeStamp: "2 days ago",
                      childName: "Milo",
                      title: "Tired Much?",
                      caption:
                          "Little Milo has been so fun the past few days. We had some formal pictures taken this week and this has got to be one of my favorites.",
                      image:
                          "https://www.uhhospitals.org/-/media/Images/Blog/Swaddle-Newborn-1343466664-Blog-MainArticleImage.jpg"),
                  const Post(
                      usersName: "Jane Doe",
                      timeStamp: "4 days ago",
                      childName: "Leif",
                      image:
                          "https://images.pexels.com/photos/1648377/pexels-photo-1648377.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                  const Post(
                      usersName: "John Doe",
                      timeStamp: "1 week ago",
                      childName: "Leif",
                      title: "Babbling",
                      caption:
                          "Leif has started babbling. He is so fun to listen to as he has found that he can form words and when he does that Jane and I just oooooh and awwww and he gets all the attention.")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
