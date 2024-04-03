import 'package:babysteps/app/pages/tracking/medical/medical_database.dart';
import 'package:babysteps/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Realtime reads to load all received vaccines for the Received Vaccines card.
class VaccineStream extends StatefulWidget {
  const VaccineStream({super.key});

  @override
  _VaccineStreamState createState() => _VaccineStreamState();
}

class _VaccineStreamState extends State<VaccineStream> {
  void openVaccDialog(Map<String, dynamic> data) {

    // Display "None" if no reaction is recorded.
    String reactionToDisplay = data['reaction'];
    if(reactionToDisplay == "") {
      reactionToDisplay = "None";
    }

    showDialog(
      context: context,
        builder: (context) {
          return Dialog(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Name and date of vaccine
                    Wrap(
                      spacing: 16.0,
                      children: [
                        Text(
                          DateFormat('MM/dd/yyyy').format(data['date'].toDate()),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          "${data['vaccine']}",
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
                      child: Text(
                        "Reaction: $reactionToDisplay",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                )
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> vaccineStream = MedicalDatabaseMethods()
      .getVaccineStream(currentUser.value!.currentBaby.value!.collectionId);

    return StreamBuilder<QuerySnapshot>(
      stream: vaccineStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // An array of documents
        var allVaccineDocs = snapshot.data!.docs;

        if (allVaccineDocs.isEmpty) {
          return const Text("No vaccines recorded.");
        } else {
          return ListView(
            shrinkWrap: true,
            children: allVaccineDocs
                .map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      return ListTile(
                        title: Wrap(
                          spacing: 16.0,
                          children: [
                            Text(DateFormat('MM/dd/yyyy').format(data['date'].toDate())),
                            Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              "${data['vaccine']}",
                            ),
                          ]
                        ),
                        subtitle: data['reaction'] == "" ? null : 
                          Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            "Reaction: ${data['reaction']}"
                          ),
                        onTap: () {
                          openVaccDialog(data);
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