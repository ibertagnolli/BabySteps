import 'package:babysteps/app/pages/tracking/medical/medical_database.dart';
import 'package:babysteps/app/widgets/styles.dart';
import 'package:babysteps/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Realtime reads to load all received medications for the Recent Medications card.
class MedicineStream extends StatefulWidget {
  const MedicineStream({super.key});

  @override
  _MedicineStreamState createState() => _MedicineStreamState();
}

class _MedicineStreamState extends State<MedicineStream> {
  TextEditingController reactionController = TextEditingController();

  /// Saves reaction data to the database
  void saveReaction(Map<String, dynamic> data) async {
    String docId = data['docId'];
    Map<String, dynamic> uploaddata = {
      'medication': data['medication'],
      'date': data['date'],
      'reaction': reactionController.text,
      'type': 'medication',
    };

    // Add a new medication if the docId isn't specified (this shouldn't happen). 
    // Else, update the existing Document.
    if (docId == "") {
      await MedicalDatabaseMethods()
          .addMedication(uploaddata, currentUser.value!.currentBaby.value!.collectionId);
    } else {
      await MedicalDatabaseMethods().updateMedication(docId, uploaddata,
          currentUser.value!.currentBaby.value!.collectionId);
    }
  }

  /// Opens a readonly vaccine dialog box with medication information
  void editMedicationDialog(Map<String, dynamic> data) {
    // Display "None" if no reaction is recorded.
    String reactionToDisplay = data['reaction'];
    if(reactionToDisplay == "") {
      reactionToDisplay = "None";
    }
    reactionController.text = reactionToDisplay;

    showDialog(
      context: context,
        builder: (context) {
          return Dialog(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Name and date of medication
                        Wrap(
                          spacing: 16.0,
                          children: [
                            Text(
                              DateFormat('MM/dd/yyyy  hh:mm a').format(data['date'].toDate()),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              "${data['medication']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ]
                        ),

                        // Reaction                 
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextField(
                            enabled: true,
                            maxLength: 500,
                            maxLines: null,
                            style: const TextStyle(fontSize: 18),
                            controller: reactionController,
                          ),
                        ),
                      ],
                    ),

                    // Edit button
                    ElevatedButton(
                      onPressed: () {
                        saveReaction(data);
                        Navigator.pop(context);
                      },
                      style: blueButton(context),
                      child: const Text('Save changes'),                 
                    )
                  ],
                )
              ),
            ),
          );
        }
    );
  }

  /// Deletes a row of a vaccine entry when the row is long pressed
  void deleteRow(String docId) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: const Color(0xFFB3BEB6),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Do you want to delete this data entry?",
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 20,
                      ),
                    ),
                  ),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: ElevatedButton(
                          onPressed: () async {
                            await MedicalDatabaseMethods().deleteMedicalEntry(
                              docId,
                              currentUser.value!.currentBaby.value!
                                  .collectionId);
                          
                            Navigator.of(context, rootNavigator: true).pop();
                          }, 
                          // style is hard-coded blue button style
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(const Color(0xFF4F646F)),
                            foregroundColor: MaterialStateProperty.all(const Color(0xFFFFFAF1)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Yes',
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(const Color(0xFF4F646F)),
                          foregroundColor: MaterialStateProperty.all(const Color(0xFFFFFAF1)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: const Text(
                          'No',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 20,
                          ),
                        ),
                      )
                    ],
                  ),
                ],)
            )
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> medicationStream = MedicalDatabaseMethods()
      .getMedicationStream(currentUser.value!.currentBaby.value!.collectionId);

    return StreamBuilder<QuerySnapshot>(
      stream: medicationStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // An array of documents
        var allMedicationDocs = snapshot.data!.docs;

        if (allMedicationDocs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text("No recently recorded medications."),
          );
        } else {
          return ListView(
            shrinkWrap: true,
            children: allMedicationDocs
                .map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      data['docId'] = document.id;
                      return ListTile(
                        title: Wrap(
                          spacing: 16.0,
                          children: [
                            Text(DateFormat('MM/dd/yyyy hh:mm a').format(data['date'].toDate())),
                            Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              "${data['medication']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]
                        ),
                        subtitle: data['reaction'] == "" ? null : 
                          Text(data['reaction']),
                        onTap: () {
                          editMedicationDialog(data);
                        },
                        onLongPress: () {
                          deleteRow(document.id);
                        },
                      );
                    })
                .toList()
                .cast(),
          );
        }        
      },
    );
  }
}