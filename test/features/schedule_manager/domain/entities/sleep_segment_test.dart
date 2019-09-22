import 'package:flutter_test/flutter_test.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';

void main() {
  group('Sleep segment test', () {
    test('should detect if end is after start', () {
      var start = DateTime(2019, 1, 1, 22, 0);
      var end = DateTime(2019, 1, 2, 4, 0);
      var seg = SleepSegment(startTime: start, endTime: end);
      expect(seg.startAndEndsOnSameDay(), false);
    });
  });
}
