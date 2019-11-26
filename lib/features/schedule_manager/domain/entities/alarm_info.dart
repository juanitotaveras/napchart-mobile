import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';

// By default, alarm should be off, and ringTime should be
// same as segment end time
class AlarmInfo extends Equatable {
  // TODO: Make ringTime private
  final DateTime ringTime;
  final bool vibrationOn;
  final bool soundOn;
  AlarmInfo(
      {@required this.ringTime,
      @required this.vibrationOn,
      @required this.soundOn});

  static AlarmInfo createDefault(SleepSegment segment) {
    return AlarmInfo(
        soundOn: false, ringTime: segment.endTime, vibrationOn: true);
  }

  static AlarmInfo createDefaultUsingTime(DateTime endTime) {
    return AlarmInfo(soundOn: false, ringTime: endTime, vibrationOn: false);
  }

  DateTime getTodayRingTime() {
    // Ring can occur the next day, if current time is after today's ring
    final cur = DateTime.now();
    final dt =
        DateTime(cur.year, cur.month, cur.day, ringTime.hour, ringTime.minute);
    if (dt.isAfter(cur)) {
      return DateTime(
          cur.year, cur.month, cur.day + 1, ringTime.hour, ringTime.minute);
    }
    return dt;
  }

  bool get isOn => this.soundOn && this.vibrationOn;

  AlarmInfo clone({DateTime ringTime, bool vibrationOn, bool soundOn}) {
    return AlarmInfo(
        ringTime: ringTime ?? this.ringTime,
        vibrationOn: vibrationOn ?? this.vibrationOn,
        soundOn: soundOn ?? this.soundOn);
  }
}
