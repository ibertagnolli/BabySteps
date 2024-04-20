//This file contains the page for a new post entry
import 'dart:async';
import 'dart:io';

import 'package:babysteps/app/pages/social/social_database.dart';
import 'package:babysteps/main.dart';
import 'package:babysteps/model/baby.dart';
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
  bool error = false;
  List<String> selectedBabyIds = [];
  List<String> selectedBabyNames = [];

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
      final imagesRef = storageRef.child(currentUser.value!.uid);
      final imageRef = imagesRef.child(now.toIso8601String());

      try {
        await imageRef.putFile(_imgFile!);
        filePath = await imageRef.getDownloadURL();
      } catch (e) {
        // ...
      }
    }

    Map<String, dynamic> uploaddata = {
      'usersName': currentUser.value!.name,
      'date': now,
      'title': title.text == '' ? null : title.text,
      'caption': caption.text == '' ? null : caption.text,
      'child': selectedBabyNames,
      'image': filePath,
      'likes': [],
      'comments': [],
    };

    for (String babyId in selectedBabyIds) {
      await SocialDatabaseMethods().addPost(uploaddata, babyId);
    }

    //once data has been added, update the card accordingly
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
    List<Baby> babies = [];

    if (currentUser.value!.babies != null) {
      List<Baby> allBabies = currentUser.value!.babies!;
      for (Baby baby in allBabies) {
        if (baby.primaryCaregiverUid == currentUser.value!.uid) {
          babies.add(baby);
        } else {
          dynamic babyCaregiver = baby.caregivers
              .where((caregiver) => caregiver['uid'] == currentUser.value!.uid)
              .firstOrNull;
          if (babyCaregiver != null && babyCaregiver['canPost'] == true) {
            babies.add(baby);
          }
        }
      }
    }
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
                                    color:
                                        Theme.of(context).colorScheme.primary),
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
                                    color:
                                        Theme.of(context).colorScheme.primary),
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
                                "Add a photo",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                child: SizedBox(
                  width: cardWidth,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButton<String>(
                      dropdownColor: Theme.of(context).cardColor,
                      isExpanded: true,
                      items: [
                        for (Baby baby in babies)
                          DropdownMenuItem(
                            value: baby.name,
                            child: StatefulBuilder(
                              builder: (context, _setState) => CheckboxListTile(
                                tileColor: Theme.of(context).cardColor,
                                title: Text(baby.name),
                                onChanged: (bool? value) {
                                  _setState(() {
                                    if (value != null) {
                                      if (value) {
                                        selectedBabyIds.add(baby.collectionId);
                                        selectedBabyNames.add(baby.name);
                                      } else {
                                        selectedBabyIds
                                            .remove(baby.collectionId);
                                        selectedBabyNames.remove(baby.name);
                                      }
                                    }
                                  });
                                  setState(() {
                                    selectedBabyIds;
                                    selectedBabyNames;
                                  });
                                },
                                value:
                                    selectedBabyIds.contains(baby.collectionId),
                              ),
                            ),
                          ),
                      ],
                      onChanged: (value) {},
                      hint: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(selectedBabyIds.isEmpty
                              ? 'Select children'
                              : selectedBabyNames.join(", "))),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextField(
                  controller: title,
                  cursorColor: Theme.of(context).colorScheme.onSecondary,
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
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  cursorColor: Theme.of(context).colorScheme.onSecondary,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      labelText: 'Caption...',
                      helperText: 'Optional'),
                ),
              ),
              const SizedBox(height: 4),
              if (error)
                Text(
                  "A baby must be selected and either a photo, title, or caption must be added!",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 4),
              FilledButton.tonal(
                onPressed: () {
                  if (selectedBabyNames.isEmpty ||
                      (_imgFile == null &&
                          caption.text == '' &&
                          title.text == '')) {
                    setState(() {
                      error = true;
                    });
                    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
                      setState(() {
                        error = false;
                      });
                      timer.cancel();
                    });
                  } else {
                    createPost();
                    Navigator.of(context).pop();
                  }
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
