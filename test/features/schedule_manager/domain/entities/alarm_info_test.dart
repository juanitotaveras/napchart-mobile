import 'package:flutter_test/flutter_test.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';

void main() {
  test(
      'ringTime should occur next day if current time is after today\'s ringTime',
      () {
    final alarmInfo = AlarmInfo(
        ringTime: SegmentDateTime(hr: 4), soundOn: true, vibrationOn: true);
    final now = DateTime(2020, 1, 18, 5);
    expect(alarmInfo.getTodayRingTime(now).day,
        DateTime(now.year, now.month, now.day).day + 1);
  });

  test('ringTime should occur same day if current time is before ringTime', () {
    final alarmInfo = AlarmInfo(
        ringTime: SegmentDateTime(hr: 4), soundOn: true, vibrationOn: true);
    final now = DateTime(2020, 1, 18, 3);
    expect(alarmInfo.getTodayRingTime(now).day,
        DateTime(now.year, now.month, now.day).day);
  });
}
