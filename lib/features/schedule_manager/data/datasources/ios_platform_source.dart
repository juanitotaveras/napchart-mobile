import 'package:polysleep/features/schedule_manager/data/datasources/platform_source.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';

class IOSPlatformSourceImpl implements PlatformSource {
  @override
  Future<void> setAlarm(AlarmInfo alarmInfo) {
    // TODO: implement setAlarm
    return null;
  }

  @override
  Future<void> deleteAlarm(AlarmInfo alarmInfo) {
    // TODO: implement deleteAlarm
    return null;
  }
}
