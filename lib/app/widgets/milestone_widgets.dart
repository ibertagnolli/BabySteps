import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:babysteps/app/pages/calendar/milestones.dart';

class MilestonesWidget extends StatelessWidget {
  final int monthsAlive;

  const MilestonesWidget({super.key, required this.monthsAlive});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        backgroundColor: Theme.of(context).colorScheme.surface,
        collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Month $monthsAlive Milestones',
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        initiallyExpanded: true,
        children: <Widget>[
          DefaultTabController(
            length: 4, // Number of tabs
            child: Column(
              children: [
                Container(
            color:Theme.of(context).colorScheme.secondary,        // Tab Bar color change 
             child: 
                TabBar(
                indicatorColor: Theme.of(context).colorScheme.primary, // Color of selected tab
                labelColor: Theme.of(context).colorScheme.onSecondary,
                  tabs: const [
                    Tab(text: 'Social'),
                    Tab(text: 'Communication'),
                    Tab(text: 'Cognitive'),
                    Tab(text: 'Movement'),
                  ],
                ),
                ),
                SizedBox(
                  height: 200, // Adjust height as needed
                  child: TabBarView(
                    children: [
                      // Social/Emotional Tab
                      ListView(
                        children: [
                          ListTile(
                            title:const Text(
                              'Social/Emotional Milestones',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                
                                for (String milestone in Milestones.socialEmotionalMilestonesByMonth[monthsAlive] ?? [])
                                  Text('• $milestone'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Language/Communication Tab
                      ListView(
                        children: [
                          ListTile(
                            title:const Text(
                              'Language/Communication Milestones',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (String milestone in Milestones.languageCommunicationMilestonesByMonth[monthsAlive] ?? [])
                                  Text('• $milestone'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Cognitive Tab
                      ListView(
                        children: [
                          ListTile(
                            title: const Text(
                              'Cognitive Milestones',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (String milestone in Milestones.cognitiveMilestonesByMonth[monthsAlive] ?? [])
                                  Text('• $milestone'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Movement/Physical Development Tab
                      ListView(
                        children: [
                          ListTile(
                            title:const Text(
                              'Movement/Physical Development Milestones',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (String milestone in Milestones.movementPhysicalDevelopmentMilestonesByMonth[monthsAlive] ?? [])
                                  Text('• $milestone'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
    );
  }
}
