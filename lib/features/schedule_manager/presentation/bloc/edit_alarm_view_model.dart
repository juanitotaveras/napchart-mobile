import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/view_model_provider.dart';
import 'package:rxdart/rxdart.dart';

class EditAlarmViewModel implements ViewModelBase {
  //! stream
  final currentAlarmSubject = BehaviorSubject<AlarmInfo>();
  Stream<AlarmInfo> get currentAlarmStream => currentAlarmSubject.stream;
  AlarmInfo get currentAlarm => currentAlarmSubject.value;

  SleepSegment currentSegment;

  //! event handler
  void setCurrentAlarm(AlarmInfo alarmInfo) {
    currentAlarmSubject.add(alarmInfo);
  }

  void switchAlarmOnValue(bool newValue) {
    final alarmInfo = AlarmInfo(
        soundOn: !currentAlarm.isOn,
        vibrationOn: !currentAlarm.isOn,
        ringTime: currentAlarm.ringTime);
    currentAlarmSubject.add(alarmInfo);
  }

  @override
  void dispose() {
    currentAlarmSubject.close();
  }
}
