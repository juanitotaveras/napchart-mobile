import 'package:polysleep/features/schedule_manager/domain/entities/notification_info.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';

class NotificationInfoModel extends NotificationInfo {
  static String isOnKey = 'isOn';
  static String notifyTimeKey = 'notifyTime';

  NotificationInfoModel({bool isOn, DateTime notifyTime})
      : super(isOn: isOn, notifyTime: notifyTime);

  factory NotificationInfoModel.fromJson(Map<String, dynamic> json) {
    final isOn = json[isOnKey] as bool;
    final notifyTime = json[notifyTimeKey]
        .split(':')
        .map<int>((elem) => int.parse(elem))
        .toList();
    return NotificationInfoModel(
        isOn: isOn,
        notifyTime: SegmentDateTime(hr: notifyTime[0], min: notifyTime[1]));
  }

  Map<String, dynamic> toJson() {
    return {
      isOnKey: this.isOn,
      notifyTimeKey: [
        _setZeroes(this.notifyTime.hour),
        _setZeroes(this.notifyTime.minute)
      ].join(':')
    };
  }

  String _setZeroes(int time) {
    // will convert 6 to 06
    String st = time.toString();
    while (st.length < 2) st = '0' + st;
    return st;
  }
}
