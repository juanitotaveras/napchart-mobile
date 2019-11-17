import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';

class AlarmInfoModel extends AlarmInfo {
  static String soundOnKey = 'soundOn';
  static String vibrationOnKey = 'vibrationOn';
  static String ringTimeKey = 'ringTime';
  AlarmInfoModel({bool soundOn, DateTime ringTime, bool vibrationOn})
      : super(soundOn: soundOn, ringTime: ringTime, vibrationOn: vibrationOn);

  factory AlarmInfoModel.fromJson(Map<String, dynamic> json) {
    final soundOn = json[soundOnKey] as bool;
    final vibrationOn = json[vibrationOnKey] as bool;
    final ringTime = json[ringTimeKey]
        .split(':')
        .map<int>((elem) => int.parse(elem))
        .toList();
    return AlarmInfoModel(
        soundOn: soundOn,
        vibrationOn: vibrationOn,
        ringTime: SegmentDateTime(hr: ringTime[0], min: ringTime[1]));
  }

  Map<String, dynamic> toJson() {
    final ringSt = [
      _setZeroes(this.ringTime.hour),
      _setZeroes(this.ringTime.minute)
    ].join(':');
    return {
      soundOnKey: this.soundOn,
      vibrationOnKey: this.vibrationOn,
      ringTimeKey: ringSt,
    };
  }

  String _setZeroes(int time) {
    // will convert 6 to 06
    String st = time.toString();
    while (st.length < 2) st = '0' + st;
    return st;
  }
}
