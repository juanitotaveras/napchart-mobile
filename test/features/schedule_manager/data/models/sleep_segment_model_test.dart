import 'dart:convert';
import 'dart:io';

import 'package:polysleep/features/schedule_manager/data/models/sleep_segment_model.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixtures_reader.dart';

void main() {
  final tSegmentModel = SleepSegmentModel(
      startTime: SegmentDateTime(hr: 22), endTime: SegmentDateTime(hr: 6));
  final tEndtime = SegmentDateTime(hr: 6);
  final tSegmentModelWithAlarm = SleepSegmentModel(
      startTime: SegmentDateTime(hr: 22),
      endTime: SegmentDateTime(hr: 6),
      alarmInfo: AlarmInfo.createDefaultUsingTime(tEndtime));
  test('should be a subclass of SleepSegment entity', () async {
    //assert
    expect(tSegmentModel, isA<SleepSegment>());
  });

  group('fromJson', () {
    test('should return valid model from Json', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('test_segment.json'));

      // act
      final result = SleepSegmentModel.fromJson(jsonMap);

      // assert
      expect(result, tSegmentModel);
    });
  });

  test('should return model with alarmSettings from Json', () async {
    // arrange
    final Map<String, dynamic> jsonMap =
        json.decode(fixture('test_segment_alarm.json'));

    // act
    final result = SleepSegmentModel.fromJson(jsonMap);

    // assert
    expect(result, tSegmentModelWithAlarm);
  });

  group('toJson', () {
    test('should return valid json from model', () async {
      // arrange and act
      final result = tSegmentModel.toJson();
      // assert
      final expectedMap = {'start': '22:00', 'end': '06:00'};
      expect(result, expectedMap);
    });
  });
}
