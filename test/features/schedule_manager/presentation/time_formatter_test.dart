import 'package:flutter_test/flutter_test.dart';
import 'package:polysleep/features/schedule_manager/presentation/time_formatter.dart';

void main() {
  group('time formatter testing', () {
    test('test format sleep time', () {
      final sleepMin = 120;
      expect('2h', TimeFormatter.formatSleepTime(sleepMin));
    });
  });
}
