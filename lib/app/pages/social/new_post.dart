//This file contains the page for a new post entry
import 'dart:io';

import 'package:babysteps/app/pages/social/social_database.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<StatefulWidget> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePostPage> {
  //Controllers for text fields
  TextEditingController title = TextEditingController();
  TextEditingController caption = TextEditingController();
  File? _imgFile;

  void takeSnapshot(bool fromCamera) async {
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: fromCamera
          ? ImageSource.camera
          : ImageSource.gallery, // alternatively, use ImageSource.gallery
      maxWidth: 400,
    );
    if (img == null) return;
    setState(() {
      _imgFile = File(img.path); // convert it to a Dart:io file
    });
  }

  void createPost() async {
    String? filePath;
    DateTime now = DateTime.now();
    if (_imgFile != null) {
      final storageRef = FirebaseStorage.instance.ref();
      final imagesRef = storageRef.child(currentUser.uid!);
      final imageRef = imagesRef.child(now.toIso8601String());

      try {
        await imageRef.putFile(_imgFile!);
        filePath = await imageRef.getDownloadURL();
      } catch (e) {
        // ...
      }
    }

    Map<String, dynamic> uploaddata = {
      'usersName':currentUser.uid,
      'date': now,
      'title': title.text == '' ? null : title.text,
      'caption': caption.text == '' ? null : caption.text,
      'child': currentUser.babies[0].name, //TODO: update this to be the baby you're posting
      'image': filePath,
    };

    await SocialDatabaseMethods().addPost(uploaddata);
    //once data has been added, update the card accordingly
  }

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
                padding: const EdgeInsets.all(32),
                //If a photo has been added, show it, if not show the 'add photo' box
                child: InkWell(
                  onTap: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton(
                              onPressed: () {
                                takeSnapshot(false);
                                Navigator.pop(context);
                              },
                              child: Text(
                                'From Gallery',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextButton(
                              onPressed: () {
                                takeSnapshot(true);
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Take Photo',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  child: _imgFile != null
                      ? Image(image: FileImage(_imgFile!))
                      : Container(
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
                padding: const EdgeInsets.symmetric(horizontal: 32),
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
                padding: const EdgeInsets.symmetric(horizontal: 32),
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
                  createPost();
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.surface),
                ),
                child: const Text("Post", style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
