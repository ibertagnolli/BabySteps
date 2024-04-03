import 'package:babysteps/app/pages/tracking/medical/add_vaccine_card.dart';
import 'package:babysteps/app/pages/tracking/medical/received_vaccinations.dart';
import 'package:babysteps/app/widgets/loading_widget.dart';
import 'package:babysteps/main.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class VaccinationsPage extends StatefulWidget {
  const VaccinationsPage({super.key});

  @override
  State<VaccinationsPage> createState() => _VaccinationsPageState();
}

class _VaccinationsPageState extends State<VaccinationsPage> {
  @override
  Widget build(BuildContext context) {
    // Nav bar
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Tracking'),
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      
      // Body
      body: SingleChildScrollView(
          child: ValueListenableBuilder(
        valueListenable: currentUser,
        builder: (context, value, child) {
          if (value == null) {
            return const LoadingWidget();
          } else {
            return Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text('Vaccinations',
                        style: TextStyle(
                            fontSize: 36,
                            color: Theme.of(context).colorScheme.onBackground)),
                  ),

                  // Add vaccine card
                  const Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: AddVaccineCard(),
                  ),

                  // Received vaccines card
                  const Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 30, left: 15, right: 15),
                    child: ReceivedVaccinationsCard(),
                  ),

                  // History Card - in widgets
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 10),
                  //   child: HistoryDropdown("breastfeeding"),
                  // ),
                ],
              ),
            );
          }
        },
      )),
    );
  }
}
