import 'package:flutter/material.dart';

/// Same as TrackingCard widget but different colors.
/// On feeding landing page and medical landing page.
class TrackingOptionCard extends StatelessWidget {
  const TrackingOptionCard(
      this.icon, this.name, this.extraInfo, this.pageFunc, this.theme,
      {super.key});
  final Icon icon;
  final String name;
  final String extraInfo;
  final void Function() pageFunc;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: theme.colorScheme.primary,
      child: InkWell(
        splashColor: theme.colorScheme.primary,
        onTap: pageFunc,
        child: SizedBox(
          width: 360,
          height: 80,
          child: Row(
            children: [
              Padding(padding: const EdgeInsets.all(16), child: icon),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    Text(
                      extraInfo,
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                    child: Icon(Icons.arrow_circle_right_outlined,
                        size: 30, color: theme.colorScheme.onPrimary)),
              )
            ],
          ),
        ),
      ),
    );
  }
}