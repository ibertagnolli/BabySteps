import 'package:babysteps/app/pages/social/social_database.dart';
import 'package:babysteps/app/widgets/social_widgets.dart';
import 'package:babysteps/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentStream extends StatefulWidget {
  const CommentStream(this.postId, {super.key});

  final String postId;

  @override
  State<StatefulWidget> createState() => _CommentStreamState();
}

class _CommentStreamState extends State<CommentStream> {
  final Stream<QuerySnapshot> _commentStream = SocialDatabaseMethods()
      .getStream(currentUser.value!.currentBaby.value!.collectionId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _commentStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        var commentWidgets = List<Widget>.empty(growable: true);

        if (snapshot.data != null) {
          var posts = snapshot.data!.docs;

          for (QueryDocumentSnapshot post in posts) {
            if (post.id == widget.postId) {
              List<dynamic> comments = post['comments'];

              for (dynamic comment in comments) {
                commentWidgets.add(Comment(
                    name: comment['name'],
                    timeStamp: (comment['time'] as Timestamp).toDate(),
                    comment: comment['comment'],
                    postDoc: post.id));
              }
            }
          }
        }

        return Column(children: [
          Column(
              children: commentWidgets.isNotEmpty
                  ? commentWidgets
                  : const [Text("no comments")]),
        ]);
      },
    );
  }
}
