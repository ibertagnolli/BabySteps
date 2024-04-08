import 'package:babysteps/app/pages/tracking/diaper/diaper_database.dart';
import 'package:babysteps/app/pages/tracking/feeding/feeding_database.dart';
import 'package:babysteps/app/pages/tracking/medical/medical_database.dart';
import 'package:babysteps/app/pages/tracking/tracking_widgets.dart';
import 'package:babysteps/app/pages/tracking/sleep/sleep_database.dart';
import 'package:babysteps/app/pages/tracking/temperature/temperature_database.dart';
import 'package:babysteps/app/pages/tracking/weight/weight_database.dart';
import 'package:babysteps/main.dart';
import 'package:babysteps/model/baby.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  @override
  Widget build(BuildContext context) {
    String babyDoc = currentUser.value!.currentBaby.value!.collectionId;
    Stream<QuerySnapshot> feedingStream =
        FeedingDatabaseMethods().getFeedingStream(babyDoc);
    Stream<QuerySnapshot> sleepStream =
        SleepDatabaseMethods().getStream(babyDoc);
    Stream<QuerySnapshot> diaperStream =
        DiaperDatabaseMethods().getStream(babyDoc);
    Stream<QuerySnapshot> weightStream =
        WeightDatabaseMethods().getStream(babyDoc);
    Stream<QuerySnapshot> tempStream =
        TemperatureDatabaseMethods().getStream(babyDoc);
    Stream<QuerySnapshot> medicalStream =
        MedicalDatabaseMethods().getStream(babyDoc);

    List<Baby> trackingBabies = [];
    if (currentUser.value!.babies != null) {
      List<Baby> babyList = currentUser.value!.babies!;
      for (Baby baby in babyList) {
        if (baby.primaryCaregiverUid == currentUser.value!.uid) {
          trackingBabies.add(baby);
        } else {
          for (dynamic caregiver in baby.caregivers) {
            if (caregiver['trackingView'] == true) {
              trackingBabies.add(baby);
            }
          }
        }
      }
    }
    print(trackingBabies.length);

    // Clickable TrackingCards to each tracking page
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Column(
            children: [
              if (currentUser.value!.babies != null &&
                  trackingBabies.length > 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: DropdownMenu<Baby>(
                        initialSelection: currentUser.value!.currentBaby.value,
                        onSelected: (value) {
                          if (value != null) {
                            currentUser.value!.currentBaby.value = value;
                          }
                          setState(() {
                            feedingStream = FeedingDatabaseMethods()
                                .getFeedingStream(babyDoc);
                            sleepStream =
                                SleepDatabaseMethods().getStream(babyDoc);
                            diaperStream =
                                DiaperDatabaseMethods().getStream(babyDoc);
                            weightStream =
                                WeightDatabaseMethods().getStream(babyDoc);
                            tempStream =
                                TemperatureDatabaseMethods().getStream(babyDoc);
                            medicalStream =
                                MedicalDatabaseMethods().getStream(babyDoc);
                          });
                        },
                        dropdownMenuEntries: trackingBabies
                            .map((baby) => DropdownMenuEntry(
                                value: baby, label: baby.name))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              TrackingStream(const Icon(Icons.local_drink, size: 40), "Feeding",
                  '/tracking/feeding',
                  stream: feedingStream),
              TrackingStream(
                  const Icon(Icons.crib, size: 40), "Sleep", '/tracking/sleep',
                  stream: sleepStream),
              TrackingStream(const Icon(Icons.baby_changing_station, size: 40),
                  'Diaper Change', '/tracking/diaper',
                  stream: diaperStream),
              TrackingStream(
                const Icon(Icons.scale, size: 40),
                "Weight",
                '/tracking/weight',
                stream: weightStream,
              ),
              TrackingStream(
                const Icon(Icons.thermostat, size: 40),
                "Temperature",
                '/tracking/temperature',
                stream: tempStream,
              ),
              TrackingStream(const Icon(Icons.medical_services, size: 40),
                  'Medical', '/tracking/medical',
                  stream: medicalStream),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
