import 'package:meta/meta.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';

import '../../domain/entities/sleep_segment.dart';

class SleepSegmentModel extends SleepSegment {
  SleepSegmentModel(
      {@required DateTime startTime,
      @required DateTime endTime,
      AlarmInfo alarmInfo})
      : super(startTime: startTime, endTime: endTime, alarmInfo: alarmInfo);

  factory SleepSegmentModel.fromJson(Map<String, dynamic> json) {
    final start =
        json['start'].split(':').map<int>((elem) => int.parse(elem)).toList();
    final end =
        json['end'].split(':').map<int>((elem) => int.parse(elem)).toList();
    return SleepSegmentModel(
        startTime: SegmentDateTime(hr: start[0], min: start[1]),
        endTime: SegmentDateTime(hr: end[0], min: end[1]));
  }

  Map<String, dynamic> toJson() {
    return {
      'start': [
        _setZeroes(this.startTime.hour),
        _setZeroes(this.startTime.minute)
      ].join(':'),
      'end': [_setZeroes(this.endTime.hour), _setZeroes(this.endTime.minute)]
          .join(':')
    };
  }

  String _setZeroes(int time) {
    // will convert 6 to 06
    String st = time.toString();
    while (st.length < 2) st = '0' + st;
    return st;
  }
}
