import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';

abstract class PlatformSource {
  Future<void> setAlarm(AlarmInfo ringTime);
  Future<void> deleteAlarm(AlarmInfo alarmInfo);
}
