import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_schedule_model.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';

import '../../../../fixtures/fixtures_reader.dart';

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

  test('should get seconds until next nap if nap is next day', () {
    final everymanSchedule = SleepScheduleModel.fromJson(
        json.decode(fixture('test_everyman_1.json')));
    final core = everymanSchedule.segments[0];
    final nap = everymanSchedule.segments[1];

    core.setIsSelected(false);
    nap.setIsSelected(true);

    final testTime = DateTime(2019, 11, 22, 21, 20);
    int howLong = everymanSchedule.getSecondsUntilNextNap(testTime);

    // assert
    expect(howLong, 56400);
  });

  test('should get seconds until next nap if nap is on same day', () {
    final everymanSchedule = SleepScheduleModel.fromJson(
        json.decode(fixture('test_everyman_1.json')));
    final core = everymanSchedule.segments[0];
    final nap = everymanSchedule.segments[1];

    core.setIsSelected(true);
    nap.setIsSelected(false);

    final testTime = DateTime(2019, 11, 22, 21, 20);
    int howLong = everymanSchedule.getSecondsUntilNextNap(testTime);

    // assert
    expect(
      howLong,
      6000,
    );
  });

  test('should pass equality test', () {
    final s1 = SleepScheduleModel.fromJson(
        json.decode(fixture('test_everyman_1.json')));
    final s2 = SleepScheduleModel.fromJson(
        json.decode(fixture('test_everyman_1.json')));
    expect(true, s1 == s2);
  });

  test('should fail equality test', () {
    final s1 = SleepScheduleModel.fromJson(
        json.decode(fixture('test_everyman_1.json')));
    final s2 =
        SleepScheduleModel.fromJson(json.decode(fixture('test_schedule.json')));
    expect(false, s1 == s2);
  });
}
