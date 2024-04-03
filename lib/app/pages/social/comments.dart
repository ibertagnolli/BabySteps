import 'package:babysteps/app/pages/social/comment_stream.dart';
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
              return SingleChildScrollView(
                child: Column(
                  children: [
                    CommentStream(widget.postId),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: TextField(
                        controller: controller,
                        textInputAction: TextInputAction.go,
                        onSubmitted: (value) => print(value),
                        decoration: InputDecoration(
                          label: const Text('comment...'),
                          suffixIcon: IconButton(
                            onPressed: controller.clear,
                            icon: const Icon(Icons.clear),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ));
  }
}
