import 'package:flutter_test/flutter_test.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';

void main() {
  final tSegments = [
    SleepSegment(
        startTime: SegmentDateTime(hr: 23), endTime: SegmentDateTime(hr: 5)),
    SleepSegment(
        startTime: SegmentDateTime(hr: 12),
        endTime: SegmentDateTime(hr: 12, min: 30))
  ];
  final tSleepSchedule = SleepSchedule(name: "Biphasic", segments: tSegments);
  setUp(() {});

  test('should calculate total sleep min', () {
    // act and assert
    expect(tSleepSchedule.totalSleepMinutes, 390);
  });

  test('should calculate total awake min', () {
    // act and assert
    expect(tSleepSchedule.totalAwakeMinutes, 1050);
  });
}
