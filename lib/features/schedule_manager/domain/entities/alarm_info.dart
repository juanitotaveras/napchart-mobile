import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';

// By default, alarm should be off, and ringTime should be
// same as segment end time
class AlarmInfo extends Equatable {
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

  bool get isOn => this.soundOn && this.vibrationOn;
}
