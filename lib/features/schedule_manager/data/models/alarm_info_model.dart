import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';

class AlarmInfoModel extends AlarmInfo {
  static String soundOnKey = 'soundOn';
  static String vibrationOnKey = 'vibrationOn';
  static String ringTimeKey = 'ringTime';
  static String alarmCodeKey = 'alarmCode';
  AlarmInfoModel(
      {bool soundOn, DateTime ringTime, bool vibrationOn, int alarmCode})
      : super(
            soundOn: soundOn,
            ringTime: ringTime,
            vibrationOn: vibrationOn,
            alarmCode: alarmCode);

  factory AlarmInfoModel.fromJson(Map<String, dynamic> json) {
    final soundOn = json[soundOnKey] as bool;
    final vibrationOn = json[vibrationOnKey] as bool;
    final ringTime = json[ringTimeKey]
        .split(':')
        .map<int>((elem) => int.parse(elem))
        .toList();
    final alarmCode = json[alarmCodeKey];
    return AlarmInfoModel(
        soundOn: soundOn,
        vibrationOn: vibrationOn,
        ringTime: SegmentDateTime(hr: ringTime[0], min: ringTime[1]),
        alarmCode: alarmCode);
  }

  factory AlarmInfoModel.fromEntity(AlarmInfo alarmInfo) {
    if (alarmInfo == null) return null;
    return AlarmInfoModel(
        ringTime: alarmInfo.ringTime,
        soundOn: alarmInfo.soundOn,
        vibrationOn: alarmInfo.vibrationOn,
        alarmCode: alarmInfo.alarmCode);
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
      alarmCodeKey: this.alarmCode
    };
  }

  static AlarmInfo createDefaultUsingTime(DateTime endTime) {
    return AlarmInfo(soundOn: false, ringTime: endTime, vibrationOn: false);
  }

  String _setZeroes(int time) {
    // will convert 6 to 06
    String st = time.toString();
    while (st.length < 2) st = '0' + st;
    return st;
  }
}
