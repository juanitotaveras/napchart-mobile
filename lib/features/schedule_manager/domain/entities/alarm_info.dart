import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';

// By default, alarm should be off, and ringTime should be
// same as segment end time
class AlarmInfo extends Equatable {
  final DateTime ringTime;
  final bool vibrationOn;
  final bool soundOn;
  final int alarmCode; // Used for setting alarms in OS
  // alarmCode will be null if it's an "unsaved" alarm
  AlarmInfo(
      {@required this.ringTime,
      @required this.vibrationOn,
      @required this.soundOn,
      this.alarmCode})
      : super([ringTime, vibrationOn, soundOn, alarmCode]);

  static AlarmInfo createDefault(SleepSegment segment) =>
      AlarmInfo(soundOn: false, ringTime: segment.endTime, vibrationOn: true);

  static AlarmInfo createDefaultUsingTime(DateTime endTime) =>
      AlarmInfo(soundOn: false, ringTime: endTime, vibrationOn: false);

  DateTime getTodayRingTime(DateTime currentTime) {
    // Ring can occur the next day, if current time is after today's ring
    final normalizedRingTime = DateTime(currentTime.year, currentTime.month,
        currentTime.day, ringTime.hour, ringTime.minute);
    if (normalizedRingTime.isBefore(currentTime)) {
      return DateTime(currentTime.year, currentTime.month, currentTime.day + 1,
          ringTime.hour, ringTime.minute);
    }
    return normalizedRingTime;
  }

  bool get isOn => this.soundOn && this.vibrationOn;

  AlarmInfo clone(
      {DateTime ringTime, bool vibrationOn, bool soundOn, int alarmCode}) {
    return AlarmInfo(
        ringTime: ringTime ?? this.ringTime,
        vibrationOn: vibrationOn ?? this.vibrationOn,
        soundOn: soundOn ?? this.soundOn,
        alarmCode: alarmCode ?? this.alarmCode);
  }
}
