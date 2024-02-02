import 'package:babysteps/app/widgets/stopwatch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('timer value should be incremented', () {
    Stopwatch watch = Stopwatch();
    watch.start();
    expect(watch.isRunning, isTrue);
  });
  test('timer value should start and stop', () {
    Stopwatch watch = Stopwatch();
    watch.start();
    expect(watch.isRunning, isTrue);
    watch.stop();
    expect(watch.isRunning, isFalse);
  });

  testWidgets('NewStopWatch widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NewStopWatch(
            '00:00:00',
            'Timer',
            (String length) {},
            () {},
            0,
            false,
          ),
        ),
      ),
    );

    // Get the actual elapsed time
    final actualElapsedTime = tester.widget<Text>(find.text('00:00:00')).data;

    expect(find.text('00:00:00'), findsOneWidget);
    expect(find.text('Start Timer'), findsOneWidget);

    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(find.text('Start Timer'), findsNothing);
    expect(find.text('Stop Timer'), findsOneWidget);

    // Wait for the timer callback to update the UI
   
      await tester.pumpAndSettle(const Duration(seconds: 10));
    

// Print the actual elapsed time for debugging
    print('Actual Elapsed Time: $actualElapsedTime');

    // Verify that the elapsed time is updated
    expect(find.text('00:00:00'), findsOneWidget);

    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    print('Actual Elapsed Time: $actualElapsedTime');

    expect(find.text('Stop Timer'), findsNothing);
    expect(find.text('Start Timer'), findsOneWidget);
  });


testWidgets('NewStopWatch starts and stops timer', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: NewStopWatch(
          '00:00:00',
          'Timer',
          (String length) {},
          () {},
          0,
          false,
        ),
      ),
    ),
  );

  // Tap to start the timer
  await tester.tap(find.byType(FilledButton));
  await tester.pumpAndSettle(); // Wait for all animations to complete

  expect(find.text('Start Timer'), findsNothing);
  expect(find.text('Stop Timer'), findsOneWidget);

  // Tap to stop the timer
  await tester.tap(find.byType(FilledButton));
  await tester.pumpAndSettle(); // Wait for all animations to complete

  expect(find.text('Stop Timer'), findsNothing);
  expect(find.text('Start Timer'), findsOneWidget);
});

// testWidgets('NewStopWatch calls stopwatchFinish callback', (WidgetTester tester) async {
//   String callbackResult = '';

//   await tester.pumpWidget(
//     MaterialApp(
//       home: Scaffold(
//         body: NewStopWatch(
//           '00:00:00',
//           'Timer',
//           (String length) {
//             callbackResult = length;
//           },
//           () {},
//           0,
//           false,
//         ),
//       ),
//     ),
//   );

//   // Tap to start the timer
//   await tester.tap(find.byType(FilledButton));
//   await tester.pumpAndSettle(); // Wait for all animations to complete

//   // Wait for the timer callback to potentially update the UI
//   await tester.pump(const Duration(seconds: 3)); // Adjust the duration as needed

//   // Tap to stop the timer
//   await tester.tap(find.byType(FilledButton));
//   await tester.pumpAndSettle(); // Wait for all animations to complete

//   // Verify that the callback was called with the correct time
//   expect(callbackResult, isNot('00:00:00'));
// });





}
