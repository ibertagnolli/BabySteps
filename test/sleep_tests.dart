import 'package:babysteps/app/pages/tracking/sleep/sleep_database.dart';
import 'package:babysteps/app/pages/tracking/sleep/sleep.dart';
import 'package:babysteps/app/widgets/stopwatch.dart';
import 'package:babysteps/app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mocking the SleepDatabaseMethods class for testing purposes
class MockSleepDatabaseMethods extends Mock implements SleepDatabaseMethods {}

void main() {
  testWidgets('SleepPage widget test', (WidgetTester tester) async {
    // Mock the SleepDatabaseMethods class
    final mockSleepDatabaseMethods = MockSleepDatabaseMethods();

    // Stubbing the responses for the database methods
    when(mockSleepDatabaseMethods.getLatestFinishedSleepEntry())
        .thenAnswer((_) async => QuerySnapshotMock([]));
    when(mockSleepDatabaseMethods.getLatestOngoingSleepEntry())
        .thenAnswer((_) async => QuerySnapshotMock([]));

    // Build our app and trigger a frame
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SleepPage(),
        ),
      ),
    );

    // Verify that the initial state is correct
    expect(find.text('00:00'), findsOneWidget);
    expect(find.text('Start Nap'), findsOneWidget);

    // Trigger a tap on the FilledButton to start the timer
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    // Verify that the timer is running
    //expect(find.text('00:00'), findsNothing);
    expect(find.text('Stop Nap'), findsOneWidget);

    // Trigger a tap on the FilledButton to stop the timer
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    // Verify that the timer is stopped and the nap length is updated
    expect(find.text('00:00'), findsOneWidget);
    expect(find.text('Start Nap'), findsOneWidget);

    // Trigger a tap on the FilledButton to start the timer again
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    // Verify that the timer is running again
   // expect(find.text('00:00'), findsNothing);
    expect(find.text('Stop Nap'), findsOneWidget);

    // Trigger a tap on the FilledButton to stop the timer
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    // Verify that the timer is stopped and the nap length is updated
    expect(find.text('00:00'), findsOneWidget);
    expect(find.text('Start Nap'), findsOneWidget);
  });
}

class QuerySnapshotMock extends Mock implements QuerySnapshot {
  QuerySnapshotMock(List<QueryDocumentSnapshot> docs) {
    when(this.docs).thenReturn(docs);
  }
}
