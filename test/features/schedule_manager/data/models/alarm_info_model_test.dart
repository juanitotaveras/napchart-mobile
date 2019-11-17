import 'dart:convert';
import 'dart:io';

import 'package:polysleep/features/schedule_manager/data/models/alarm_info_model.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_segment_model.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixtures_reader.dart';

void main() {
  final tAlarmInfoModel = AlarmInfoModel(
      ringTime: SegmentDateTime(hr: 22), soundOn: true, vibrationOn: true);
  test('should be subclass of AlarmInfo entity', () async {
    expect(tAlarmInfoModel, isA<AlarmInfo>());
  });

  group('from Json', () {
    test('should return valid model', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('test_alarm.json'));

      // act
      final result = AlarmInfoModel.fromJson(jsonMap);

      // assert
      expect(result, tAlarmInfoModel);
    });
  });

  group('to Json', () {
    test('should return valid json from model', () async {
      // arrange and act
      final result = tAlarmInfoModel.toJson();

      // assert
      final expectedMap = {
        AlarmInfoModel.soundOnKey: true,
        AlarmInfoModel.vibrationOnKey: true,
        AlarmInfoModel.ringTimeKey: '22:00'
      };
      expect(result, expectedMap);
    });
  });
}
