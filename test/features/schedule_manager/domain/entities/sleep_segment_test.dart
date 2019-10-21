import 'package:flutter_test/flutter_test.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';

void main() {
  group('Sleep segment test', () {
    test('should detect if end is after start', () async {
      var start = DateTime(2019, 1, 1, 22, 0);
      var end = DateTime(2019, 1, 2, 4, 0);
      var seg = SleepSegment(startTime: start, endTime: end);
      expect(seg.startAndEndsOnSameDay(), false);
    });

    test('should make end after start if endTime before startTime', () async {
      // arrange
      final start = SegmentDateTime(hr: 22);
      final end = SegmentDateTime(hr: 6);
      // act
      final seg = SleepSegment(startTime: start, endTime: end);

      // assert
      expect(seg.startAndEndsOnSameDay(), false);
    });

    test('should make start and end on same day if startTime before endTime',
        () async {
      // arrange and act
      final seg = SleepSegment(
          startTime: SegmentDateTime(hr: 12), endTime: SegmentDateTime(hr: 13));

      // assert
      expect(seg.startAndEndsOnSameDay(), true);
    });

    test('cloning should work', () async {
      final seg = SleepSegment(
          startTime: SegmentDateTime(hr: 12),
          endTime: SegmentDateTime(hr: 13),
          name: 'testSeg');
      final leClone = seg.clone();

      expect(seg, leClone);
      // expect(seg === leClone, true);
      // PROBLEM: We want to check referential equality but unfortunately we overrode ==
      // check that references are not the same
    });
  });
}
