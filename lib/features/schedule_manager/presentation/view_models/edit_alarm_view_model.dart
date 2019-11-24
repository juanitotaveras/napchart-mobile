import 'dart:async';

import 'package:flutter/material.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/view_models/view_model_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditAlarmViewModel implements ViewModelBase {
  static const platform = const MethodChannel('polysleep/alarm');
  //! stream
  final currentAlarmSubject = BehaviorSubject<AlarmInfo>();
  Stream<AlarmInfo> get currentAlarmStream => currentAlarmSubject.stream;
  AlarmInfo get currentAlarm => currentAlarmSubject.value;

  bool get unsavedChangesExist =>
      (initialAlarm.ringTime != currentAlarm.ringTime ||
          initialAlarm.soundOn != currentAlarm.soundOn ||
          initialAlarm.vibrationOn != currentAlarm.vibrationOn);

  AlarmInfo initialAlarm;

  //! event handlers
  void setCurrentAlarm(AlarmInfo alarmInfo) {
    currentAlarmSubject.add(alarmInfo);
    initialAlarm = alarmInfo;
  }

  void switchAlarmOnValue(bool newValue) {
    final alarmInfo = AlarmInfo(
        soundOn: !currentAlarm.isOn,
        vibrationOn: !currentAlarm.isOn,
        ringTime: currentAlarm.ringTime);
    currentAlarmSubject.add(alarmInfo);
  }

  void setNewTime(TimeOfDay time) {
    final dt = SegmentDateTime(hr: time.hour, min: time.minute);
    currentAlarmSubject.add(currentAlarm.clone(ringTime: dt));
  }

  void resetDefault(SleepSegment segment) {
    currentAlarmSubject.add(currentAlarm.clone(ringTime: segment.endTime));
  }

  void onSavePressed() {
    // TODO: Should call repository method to save new alarm setting
    _getRandomStringFromAndroid();
  }

  Future<void> _getRandomStringFromAndroid() async {
    print('starting');
    String res;
    try {
      final String result = await platform.invokeMethod('getRandomString');
      res = result;
    } on PlatformException catch (e) {
      res = "FAILURE";
    }
    print(res);
  }

  @override
  void dispose() {
    currentAlarmSubject.close();
  }
}
