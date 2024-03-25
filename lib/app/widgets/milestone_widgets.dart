import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:babysteps/app/pages/calendar/milestones.dart';

class MilestonesWidget extends StatelessWidget {
  final int monthsAlive;

  const MilestonesWidget({Key? key, required this.monthsAlive});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.secondary,
            child: TabBar(
              indicatorColor: Theme.of(context).colorScheme.primary,
              labelColor:Theme.of(context).colorScheme.onSecondary,
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
                _buildMilestoneList(
                  context,
                  'Social/Emotional Milestones',
                  Milestones.socialEmotionalMilestonesByMonth[monthsAlive] ?? [],
                ),
                // Language/Communication Tab
                _buildMilestoneList(
                  context,
                  'Language/Communication Milestones',
                  Milestones.languageCommunicationMilestonesByMonth[monthsAlive] ?? [],
                ),
                // Cognitive Tab
                _buildMilestoneList(
                  context,
                  'Cognitive Milestones',
                  Milestones.cognitiveMilestonesByMonth[monthsAlive] ?? [],
                ),
                // Movement/Physical Development Tab
                _buildMilestoneList(
                  context,
                  'Movement/Physical Development Milestones',
                  Milestones.movementPhysicalDevelopmentMilestonesByMonth[monthsAlive] ?? [],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneList(BuildContext context, String title, List<String> milestones) {
    return ListView(
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (String milestone in milestones)
                Text('• $milestone'),
              if (milestones.isEmpty)
                Text(
                  'No CDC recommended milestones for this month. Please check the next month.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
            ],
          ),
        ),
      ],
    );
  }
}





