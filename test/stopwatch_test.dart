// Import the test package and Counter class
import 'package:babysteps/app/widgets/stopwatch.dart';
import 'package:test/test.dart';

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

  
}