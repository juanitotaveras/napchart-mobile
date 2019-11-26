import 'dart:async';

import 'package:flutter/material.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/set_alarm.dart';
import 'package:polysleep/features/schedule_manager/presentation/view_models/view_model_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditAlarmViewModel implements ViewModelBase {
  static const platform = const MethodChannel('polysleep/alarm');

  final SetAlarm setAlarm;

  EditAlarmViewModel({@required this.setAlarm}) {
    assert(setAlarm != null);
  }

  //! stream
  final currentAlarmSubject = BehaviorSubject<AlarmInfo>();
  Stream<AlarmInfo> get currentAlarmStream => currentAlarmSubject.stream;

  // TODO: Add @visibleForTesting annotation so that value is exposed for tests only.
  // Outside of tests, we should only consume the value through streams
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

  void onSavePressed() async {
    // TODO: Should call repository method to save new alarm setting
    // If alarm does not exist, just create it.
    // If alarm already exists, we need to delete current alarm and create a new one.
    // When we delete a segment, we must delete the alarm as well!
    // _getRandomStringFromAndroid();
    // _setAlarm();
    final resp =
        await this.setAlarm(Params(ringTime: currentAlarm.getTodayRingTime()));
    resp.fold((failure) async {}, (success) async {
      print('GREAT SUCCESS!');
    });
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

  Future<void> _setAlarm() async {
    try {
      // TODO: Send the desired time
      final String success = await platform.invokeMethod(
          'setAlarm', currentAlarm.getTodayRingTime().millisecondsSinceEpoch);
      print(success);
    } on PlatformException catch (e) {}
  }

  @override
  void dispose() {
    currentAlarmSubject.close();
  }
}
