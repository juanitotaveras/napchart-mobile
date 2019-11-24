import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/view_models/edit_alarm_view_model.dart';
import 'package:polysleep/features/schedule_manager/presentation/time_formatter.dart';
import '../../localizations.dart';
import 'package:polysleep/features/schedule_manager/presentation/view_models/home_view_model.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import '../../../../../injection_container.dart';
import 'edit_alarm_modal.dart';

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

class NextNapCard extends StatelessWidget {
  final HomeViewModel vm;
  NextNapCard(this.vm);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SleepSchedule>(
        stream: vm.currentScheduleStream,
        builder: (context, currentScheduleStream) {
          if (vm.shouldShowNapNavigationArrows) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: 10.0),
                  onPressed: () {
                    vm.onLeftNapArrowTapped();
                  },
                ),
                Expanded(child: nextNapCardCentralSection(context)),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, size: 10.0),
                  onPressed: () {
                    vm.onRightNapArrowTapped();
                  },
                )
              ],
            );
          } else {
            return nextNapCardCentralSection(context);
          }
        });
  }

  Widget nextNapCardCentralSection(BuildContext ctxt) {
    SleepSegment selectedSegment = vm.currentSchedule.getSelectedSegment();
    TimeFormatter tf = TimeFormatter();
    final NextNapInfoPresenter presenter = NextNapInfoPresenter(ctxt, this.vm);

    return Card(
        child: Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Column(
                  children: <Widget>[
                    Text('Start'),
                    Text(presenter.currentNapStartTime)
                  ],
                )),
                Expanded(
                    child: Column(
                  children: <Widget>[
                    Text('End'),
                    Text(presenter.currentNapEndTime)
                  ],
                )),
                Expanded(
                    child: Column(
                  children: <Widget>[
                    Text('Duration'),
                    Text(presenter.currentNapDuration)
                  ],
                )),
              ],
            )),
        ListTile(
          title: Text('Alarm'),
          leading: Icon(
              presenter.currentNapAlarmOn ? Icons.alarm_on : Icons.alarm_off),
          subtitle: Text(presenter.currentNapAlarmInfoText),
          contentPadding: EdgeInsets.only(left: 30),
          onTap: () async {
            showModalBottomSheet(
                context: ctxt, builder: (context) => EditAlarmModal(vm));
          },
        ),
        // BasicTimeField(),
        ListTile(
            contentPadding: EdgeInsets.only(left: 30),
            title: Text('Notification'),
            leading: Icon(presenter.currentNapNotificationOn
                ? Icons.notifications_active
                : Icons.notifications_off),
            subtitle: Text(presenter.currentNapNotificationInfoText))
      ],
    ));
  }
}
