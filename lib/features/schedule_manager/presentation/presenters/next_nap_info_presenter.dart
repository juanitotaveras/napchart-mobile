import 'package:flutter/material.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/time_formatter.dart';
import 'package:polysleep/features/schedule_manager/presentation/view_models/home_view_model.dart';

class NextNapInfoPresenter {
  final BuildContext _context;
  final HomeViewModel _viewModel;
  SleepSegment selectedSegment;
  TimeFormatter tf = TimeFormatter();
  NextNapInfoPresenter(this._context, this._viewModel) {
    selectedSegment = _viewModel.currentSchedule?.getSelectedSegment();
  }

  String get currentNapStartTime => (selectedSegment == null)
      ? ""
      : tf.getMilitaryTime(selectedSegment.startTime);

  String get currentNapEndTime => (selectedSegment == null)
      ? ""
      : tf.getMilitaryTime(selectedSegment.endTime);

  String get currentNapDuration => (selectedSegment == null)
      ? ""
      : TimeFormatter.formatSleepTime(selectedSegment.getDurationMinutes());

  bool get currentNapAlarmOn =>
      (selectedSegment == null) ? false : selectedSegment.alarmInfo.isOn;

  String get currentNapAlarmInfoText {
    if (selectedSegment == null || !selectedSegment.alarmInfo.isOn) {
      return "Off";
    }
    return "Set for ${tf.getMilitaryTime(selectedSegment.alarmInfo.ringTime)}";
  }

  bool get currentNapNotificationOn =>
      (selectedSegment == null) ? false : selectedSegment.notificationInfo.isOn;

  String get currentNapNotificationInfoText {
    if (selectedSegment == null || !selectedSegment.notificationInfo.isOn) {
      return "Off";
    }
    return "Set for ${tf.getMilitaryTime(selectedSegment.notificationInfo.notifyTime)}";
  }
}
