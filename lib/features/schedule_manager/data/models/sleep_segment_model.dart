import 'package:meta/meta.dart';
import 'package:polysleep/features/schedule_manager/data/models/notification_info_model.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/notification_info.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';

import '../../domain/entities/sleep_segment.dart';
import 'alarm_info_model.dart';

class SleepSegmentModel extends SleepSegment {
  SleepSegmentModel(
      {@required DateTime startTime,
      @required DateTime endTime,
      AlarmInfo alarmInfo,
      NotificationInfo notificationInfo})
      : super(
            startTime: startTime,
            endTime: endTime,
            alarmInfo: alarmInfo,
            notificationInfo: notificationInfo);

  static String startKey = 'start';
  static String endKey = 'end';
  static String alarmInfoKey = 'alarmInfo';
  static String notificationInfoKey = 'notificationInfo';

  factory SleepSegmentModel.fromJson(Map<String, dynamic> json) {
    final start =
        json[startKey].split(':').map<int>((elem) => int.parse(elem)).toList();
    final end =
        json[endKey].split(':').map<int>((elem) => int.parse(elem)).toList();
    final startTime = SegmentDateTime(hr: start[0], min: start[1]);
    final endTime = SegmentDateTime(hr: end[0], min: end[1]);
    final alarmInfo = (json.containsKey(alarmInfoKey))
        ? AlarmInfoModel.fromJson(json[alarmInfoKey])
        : AlarmInfoModel.createDefaultUsingTime(endTime);
    final notificationInfo = (json.containsKey(notificationInfoKey))
        ? NotificationInfoModel.fromJson(json[notificationInfoKey])
        : NotificationInfo.createDefaultUsingTime(startTime);
    return SleepSegmentModel(
        startTime: startTime,
        endTime: endTime,
        alarmInfo: alarmInfo,
        notificationInfo: notificationInfo);
  }

  factory SleepSegmentModel.fromEntity(SleepSegment segment) {
    return SleepSegmentModel(
        startTime: segment.startTime,
        endTime: segment.endTime,
        alarmInfo: AlarmInfoModel.fromEntity(segment.alarmInfo),
        notificationInfo:
            NotificationInfoModel.fromEntity(segment.notificationInfo));
  }

  Map<String, dynamic> toJson() {
    final Map<String, Object> res = {
      startKey: [
        _setZeroes(this.startTime.hour),
        _setZeroes(this.startTime.minute)
      ].join(':'),
      endKey: [_setZeroes(this.endTime.hour), _setZeroes(this.endTime.minute)]
          .join(':'),
      alarmInfoKey: AlarmInfoModel.fromEntity(alarmInfo).toJson()
    };

    if (this.alarmInfo != null) {
      res[alarmInfoKey] = (AlarmInfoModel.fromEntity(this.alarmInfo)).toJson();
    }

    if (this.notificationInfo != null) {
      res[notificationInfoKey] =
          (this.notificationInfo as NotificationInfoModel).toJson();
    }
    return res;
  }

  String _setZeroes(int time) {
    // will convert 6 to 06
    String st = time.toString();
    while (st.length < 2) st = '0' + st;
    return st;
  }
}
