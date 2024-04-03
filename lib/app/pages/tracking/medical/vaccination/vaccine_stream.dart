import 'package:babysteps/app/pages/tracking/medical/medical_database.dart';
import 'package:babysteps/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VaccineStream extends StatefulWidget {
  const VaccineStream({super.key});

  @override
  _VaccineStreamState createState() => _VaccineStreamState();
}

class _VaccineStreamState extends State<VaccineStream> {
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
                        title: Row(
                          children: [
                            Text(DateFormat('MM/dd/yyyy').format(data['date'].toDate())),
                            const Text("    "),
                            Text(data['vaccine']),
                          ]
                        ),
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