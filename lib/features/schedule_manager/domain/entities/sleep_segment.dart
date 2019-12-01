import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:polysleep/core/constants.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/notification_info.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';

class SleepSegment {
  DateTime _startTime;
  DateTime _endTime;
  final String name;
  bool isSelected;
  final AlarmInfo alarmInfo;
  final NotificationInfo notificationInfo;

  DateTime get startTime => _startTime;
  DateTime get endTime => _endTime;

  SleepSegment({
    @required startTime,
    @required endTime,
    this.alarmInfo,
    this.notificationInfo,
    this.name = "",
    this.isSelected = false,
  }) {
    if (startTime.isAfter(endTime)) {
      this._startTime =
          SegmentDateTime(hr: startTime.hour, min: startTime.minute, day: 0);
      this._endTime =
          SegmentDateTime(hr: endTime.hour, min: endTime.minute, day: 1);
    } else {
      this._startTime = startTime;
      this._endTime = endTime;
    }
  }

  SleepSegment clone(
      {DateTime startTime,
      DateTime endTime,
      bool isSelected,
      AlarmInfo alarmInfo,
      NotificationInfo notificationInfo}) {
    return SleepSegment(
        startTime: startTime ?? this._startTime,
        endTime: endTime ?? this._endTime,
        notificationInfo: notificationInfo ?? this.notificationInfo,
        alarmInfo: alarmInfo ?? this.alarmInfo,
        name: this.name,
        isSelected: isSelected ?? this.isSelected);
  }

  // equality overrides
  // TODO: We are commenting out other.runtimeType
  // because when we compare SleepSegment with SleepSegmentModel,
  // equality fails.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SleepSegment &&
          _startTime.isAtSameMomentAs(other._startTime) &&
          _endTime.isAtSameMomentAs(other._endTime);

  @override
  int get hashCode => _startTime.hashCode + _endTime.hashCode;

  int getStartMinutesFromMidnight() {
    return _startTime.hour * 60 + _startTime.minute;
  }

  int getEndMinutesFromMidnight() {
    return _endTime.hour * 60 + _endTime.minute;
  }

  bool startAndEndsOnSameDay() {
    return _startTime.day == _endTime.day;
  }

  int getDurationMinutes() {
    // one minutes is 60,000 ms
    final ms =
        _endTime.millisecondsSinceEpoch - _startTime.millisecondsSinceEpoch;

    return ms ~/ 60000;
  }

  static int getTotalSleepMinutes(List<SleepSegment> segs) =>
      MINUTES_PER_DAY - getTotalAwakeMinutes(segs);

  static int getTotalAwakeMinutes(List<SleepSegment> segs) => segs
      .map((seg) => seg.getDurationMinutes())
      .reduce((segA, segB) => segA + segB);
}
