import 'package:babysteps/app/pages/social/comment_stream.dart';
import 'package:babysteps/app/pages/social/social_database.dart';
import 'package:babysteps/app/widgets/loading_widget.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class CommentsPage extends StatefulWidget {
  const CommentsPage(this.postId, {super.key});
  final String postId;

  @override
  State<StatefulWidget> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Comments'),
          leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        body: ValueListenableBuilder(
          valueListenable: currentUser,
          builder: (context, value, child) {
            if (value == null) {
              return const LoadingWidget();
            } else {
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                        child: Column(children: [
                      CommentStream(widget.postId),
                    ])),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: TextField(
                        controller: controller,
                        minLines: 1,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (value) async {
                          controller.clear();
                          await SocialDatabaseMethods().addComment({
                            'comment': value,
                            'group': '',
                            'name': currentUser.value!.name,
                            'time': DateTime.now(),
                            'uid': currentUser.value!.uid,
                          }, currentUser.value!.currentBaby.value!.collectionId,
                              widget.postId);
                        },
                        decoration: InputDecoration(
                          label: const Text('comment...'),
                          suffixIcon: IconButton(
                            onPressed: controller.clear,
                            icon: const Icon(Icons.clear),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ));
  }
}
