import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_schedule_model.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_segment_model.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';

import '../../../../fixtures/fixtures_reader.dart';

void main() {
  final tSleepSegments = [
    SleepSegmentModel(
        startTime: SegmentDateTime(hr: 22), endTime: SegmentDateTime(hr: 6))
  ];
  final tSleepScheduleModel = SleepScheduleModel(segments: tSleepSegments);

  test('should be subclass of SleepSchedule', () async {
    // assert
    expect(tSleepScheduleModel, isA<SleepSchedule>());
  });

  group('fromJson', () {
    test('should return valid model', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('test_schedule.json'));

      // act
      final result = SleepScheduleModel.fromJson(jsonMap);

      // assert
      expect(result, tSleepScheduleModel);
    });
  });
}
