import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';

class AlarmInfoModel extends AlarmInfo {
  AlarmInfoModel({bool soundOn, DateTime ringTime, bool vibrationOn})
      : super(soundOn: soundOn, ringTime: ringTime, vibrationOn: vibrationOn);

  factory AlarmInfoModel.fromJson(Map<String, dynamic> json) {
    final soundOn = json['soundOn'] as bool;
    final vibrationOn = json['vibrationOn'] as bool;
    final ringTime = json['ringTime'] as DateTime;
    return AlarmInfoModel(
        soundOn: soundOn, vibrationOn: vibrationOn, ringTime: ringTime);
  }

  Map<String, dynamic> toJson() {
    return {
      'soundOn': this.soundOn,
      'vibrationOn': this.vibrationOn,
      'ringTimme': this.ringTime,
    };
  }
}
