import 'package:babysteps/app/pages/social/social_database.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Post extends StatefulWidget {
  Post(
      {super.key,
      required this.usersName,
      required this.timeStamp,
      required this.childName,
      required this.postDoc,
      required this.likes,
      this.title,
      this.caption,
      this.image});
  final String usersName;
  final String timeStamp;
  final String childName;
  final String postDoc;
  List<dynamic> likes;
  final String? title;
  final String? caption;
  final String? image;

  @override
  State<StatefulWidget> createState() => _PostState();
}

class _PostState extends State<Post> {
  //TODO: pull from database
  late bool postLiked;

  void likeClicked() {
    setState(() {
      postLiked = !postLiked;
      if (postLiked) {
        widget.likes.add(
            {'name': currentUser.value!.name, 'uid': currentUser.value!.uid});
        SocialDatabaseMethods().addLikes(widget.likes,
            currentUser.value!.currentBaby.value!.collectionId, widget.postDoc);
      } else {
        widget.likes
            .removeWhere((like) => like['uid'] == currentUser.value!.uid);

        SocialDatabaseMethods().addLikes(widget.likes,
            currentUser.value!.currentBaby.value!.collectionId, widget.postDoc);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    postLiked =
        widget.likes.any((like) => like['uid'] == currentUser.value!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.90; // 90% of screen width
    //Update this to actually grab the initials from the user in the database, also this has a potential to break if the name is ""
    String initials = widget.usersName.isEmpty ? "A" : widget.usersName[0];

    return Card(
      child: SizedBox(
        width: cardWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                //TODO: dynamic avatar with either image or initials
                child: Text(initials),
              ),
              title: Text(widget.usersName),
              subtitle: Text(widget.timeStamp),
            ),
            //Since images are optional, check to see if we have it first, if so show it
            if (widget.image != null)
              Image(
                image: NetworkImage(widget.image!),
              ),
            ListTile(
              title: Text(widget.childName),
              //A title for the post is optional, so check if we have it, if not just set the subtitle to null
              subtitle: widget.title != null ? Text(widget.title!) : null,
            ),
            //Since the caption is also optional, check to see if we have a caption before displaying it
            if (widget.caption != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(widget.caption!, textAlign: TextAlign.left)),
              ),
            const Divider(
              indent: 16.0,
              endIndent: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                    //Todo navigate to a page to comment
                    onPressed: () => context.goNamed('/social/comments',
                        queryParameters: {'postId': widget.postDoc}),
                    icon: const Icon(Icons.chat_bubble_outline)),
                const SizedBox(width: 8),
                IconButton(
                    //toggle between a filled and empty heart
                    onPressed: () => likeClicked(),
                    icon: postLiked
                        ? const Icon(Icons.favorite, color: Colors.red)
                        : const Icon(Icons.favorite_border_outlined)),
                const SizedBox(width: 8),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                widget.likes.length == 1
                    ? Text("liked by: ${widget.likes.length.toString()} person")
                    : Text(
                        "liked by: ${widget.likes.length.toString()} people"),
                const SizedBox(width: 8),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Comment extends StatefulWidget {
  const Comment({
    super.key,
    required this.name,
    required this.timeStamp,
    required this.comment,
    required this.postDoc,
  });
  final String name;
  final DateTime timeStamp;
  final String comment;
  final String postDoc;

  @override
  State<StatefulWidget> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width;
    //Update this to actually grab the initials from the user in the database, also this has a potential to break if the name is ""
    String initials = widget.name.isEmpty ? "A" : widget.name[0];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            //TODO: dynamic avatar with either image or initials
            child: Text(initials),
          ),
          title: Row(children: [
            Text(
              "${widget.name}: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.comment)
          ]),
          subtitle: Text(widget.timeStamp.toString()),
        ),
        const Divider(),
      ],
    );
  }
}
