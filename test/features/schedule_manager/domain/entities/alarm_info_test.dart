import 'package:flutter_test/flutter_test.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';

void main() {
  test('getTodayRingTime', () {
    final alarmInfo = AlarmInfo(
        ringTime: SegmentDateTime(hr: 4), soundOn: true, vibrationOn: true);
    final now = DateTime.now();
    expect(alarmInfo.getTodayRingTime().day,
        DateTime(now.year, now.month, now.day).day);
  });
}
