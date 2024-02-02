// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:babysteps/app/pages/user/profile.dart';
import 'package:babysteps/app/widgets/social_widgets.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:babysteps/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  //  testWidgets('Profile page has name', (tester) async {
  //   // Create the widget by telling the tester to build it.
  //   //await tester.pumpWidget(ProfilePage(name: "bella"));
  //   await tester.pumpWidget(const ProfilePage());
  //   expect(find.byType(ProfilePage), findsOneWidget);
  // });

  testWidgets('tracking card has expected fields', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: TrackingCard(
            icon: const Icon(Icons.note),
            name: "other",
            hoursAgo: "8",
            pageFunc: () {})));
    final nameFinder = find.text('other');
    final timeStampFinder = find.text("8");
    expect(nameFinder, findsOneWidget);
    expect(timeStampFinder, findsOneWidget);
  });

  testWidgets('notes card has expected fields', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: NotesCard("Thing", "10", () {})));
    final nameFinder = find.text('Thing');
    //final timeStampFinder = find.text("10");
    expect(nameFinder, findsOneWidget);
    //expect(timeStampFinder, findsOneWidget);
  });

  testWidgets('post has expected fields', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(const Directionality(
        textDirection: TextDirection.ltr,
        child: Post(
            usersName: "ibertagnolli", timeStamp: "10:00", childName: "Nico")));
    final userNameFinder = find.text('ibertagnolli');
    final timeStampFinder = find.text('10:00');
    expect(userNameFinder, findsOneWidget);
    expect(timeStampFinder, findsOneWidget);
  });

  
}
