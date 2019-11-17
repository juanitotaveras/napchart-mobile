import 'dart:convert';
import 'dart:io';

import 'package:polysleep/features/schedule_manager/data/models/alarm_info_model.dart';
import 'package:polysleep/features/schedule_manager/data/models/notification_info_model.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_segment_model.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/notification_info.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixtures_reader.dart';

void main() {
  final tNotifyInfoModel =
      NotificationInfoModel(isOn: true, notifyTime: SegmentDateTime(hr: 10));
  test('should be subclass of AlarmInfo entity', () async {
    expect(tNotifyInfoModel, isA<NotificationInfo>());
  });

  group('from Json', () {
    test('should return valid model', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('test_notification.json'));

      // act
      final result = NotificationInfoModel.fromJson(jsonMap);

      // assert
      expect(result, tNotifyInfoModel);
    });
  });

  group('to Json', () {
    test('should return valid json from model', () async {
      // arrange and act
      final result = tNotifyInfoModel.toJson();

      // assert
      final expectedMap = {
        NotificationInfoModel.isOnKey: true,
        NotificationInfoModel.notifyTimeKey: '10:00'
      };
      expect(result, expectedMap);
    });
  });
}
