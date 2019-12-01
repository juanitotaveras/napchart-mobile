import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:polysleep/core/error/failure.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/set_alarm.dart';
import 'package:polysleep/features/schedule_manager/presentation/view_models/home_view_model.dart';
import 'package:polysleep/features/schedule_manager/presentation/view_models/view_model_provider.dart';
import 'package:rxdart/rxdart.dart';

class EditAlarmViewModel implements ViewModelBase {
  final SetAlarm setAlarm;
  HomeViewModel homeViewModel; // nullable

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

  void setHomeViewModel(HomeViewModel viewModel) {
    this.homeViewModel = viewModel;
    final schedule = this.homeViewModel.currentSchedule;
    final selectedSegment = schedule.getSelectedSegment();
    this.currentAlarmSubject.add(selectedSegment.alarmInfo);
    initialAlarm = selectedSegment.alarmInfo;
  }

  void switchAlarmOnValue(bool newValue) {
    final alarmInfo = currentAlarm.clone(
        soundOn: !currentAlarm.isOn, vibrationOn: !currentAlarm.vibrationOn);
    currentAlarmSubject.add(alarmInfo);
  }

  void setNewTime(TimeOfDay time) {
    final dt = SegmentDateTime(hr: time.hour, min: time.minute);
    currentAlarmSubject.add(currentAlarm.clone(ringTime: dt));
  }

  void resetDefault(SleepSegment segment) {
    final newAlarm = currentAlarm.clone(ringTime: segment.endTime);
    currentAlarmSubject.add(newAlarm);
  }

  void onSavePressed() async {
    final Either<Failure, void> result = await this.setAlarm(Params(
        alarmInfo: currentAlarmSubject.value,
        schedule: this.homeViewModel.currentSchedule));

    result.fold((failure) async {
      print('Saving alarm has failed.');
      print(failure);
    }, (_) async {
      this.homeViewModel.onLoadSchedule();
    });
  }

  @override
  void dispose() {
    currentAlarmSubject.close();
  }
}
