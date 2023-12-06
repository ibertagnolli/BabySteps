//This file contains the page for a new post entry
import 'package:flutter/material.dart';
import 'dart:core';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key, required this.addPost});
  final void Function(String userName, String time, String child,
      String? postTitle, String? cap, String? img) addPost;

  @override
  State<StatefulWidget> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePostPage> {
  //Controllers for text fields
  TextEditingController title = TextEditingController();
  TextEditingController caption = TextEditingController();

  //This is a temporary boolean for mocking data
  bool photoAdded = false;
  void addPhoto() {
    setState(() {
      photoAdded = true;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    title.dispose();
    caption.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Dynamically get the size of the page so that the 'add post' square is dynamic
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.95;
    final cardHeight = cardWidth * 0.75;
    //TODO: remove this once we're actually using a user's files for the image
    String img =
        "https://thumbs.dreamstime.com/b/sleeping-newborn-baby-blanket-59033149.jpg";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Social'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(32),
                //If a photo has been added, show it, if not show the 'add photo' box
                child: photoAdded
                    ? Image(
                        image: NetworkImage(img),
                      )
                    : InkWell(
                        onTap: () => addPhoto(),
                        child: Container(
                          height: cardHeight,
                          width: cardWidth,
                          color: Theme.of(context).colorScheme.surface,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.add, size: 40),
                              Text(
                                "Add a photo or video",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: TextField(
                  controller: title,
                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      labelText: 'Title...',
                      helperText: 'Optional'),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: TextField(
                  controller: caption,
                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      labelText: 'Caption...',
                      helperText: 'Optional'),
                ),
              ),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () {
                  //TODO: remove this call to addPost once database is hooked up
                  widget.addPost(
                      "Jim de St Germain",
                      "3 seconds ago",
                      "Aaron",
                      title.text == "" ? null : title.text,
                      caption.text == "" ? null : caption.text,
                      photoAdded
                          ? "https://thumbs.dreamstime.com/b/sleeping-newborn-baby-blanket-59033149.jpg"
                          : null);
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.surface),
                ),
                child: Text("Post", style: const TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
