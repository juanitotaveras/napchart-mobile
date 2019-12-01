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

class EditAlarmModal extends StatelessWidget {
  final HomeViewModel homeVM;
  final editAlarmVM = sl<EditAlarmViewModel>();
  EditAlarmModal(this.homeVM) {
    editAlarmVM.setHomeViewModel(homeVM);
  }
  @override
  Widget build(BuildContext context) {
    final presenter = EditAlarmModalPresenter(context, editAlarmVM, homeVM);
    final tf = TimeFormatter();
    return StreamBuilder<AlarmInfo>(
      stream: editAlarmVM.currentAlarmStream,
      builder: (context, stream) {
        final currentAlarm = stream.data;
        if (currentAlarm == null) return Container();
        final saveButtonList = (this.editAlarmVM.unsavedChangesExist)
            ? [
                RaisedButton(
                  child: Text(presenter.saveText),
                  onPressed: () {
                    this.editAlarmVM.onSavePressed();
                    Navigator.pop(context);
                  },
                ),
              ]
            : [];
        final container = Container(
          // height: mediaQueryData.size.height - 150,
          color: Theme.of(context).cardColor,
          padding: EdgeInsets.only(left: 13),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  ...saveButtonList,
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
              Row(
                children: <Widget>[SizedBox(height: 20)],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(),
                  ),
                  Icon(Icons.alarm),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    presenter.alarmHeaderText,
                    style: Theme.of(context).textTheme.title,
                  ),
                  Expanded(
                    child: SizedBox(),
                  )
                ],
              ),
              Row(
                children: <Widget>[SizedBox(height: 40)],
              ),
              Row(
                children: <Widget>[
                  Expanded(child: SizedBox()),
                  Text(presenter.alarmOnText),
                  Switch(
                    value: currentAlarm?.soundOn ?? false,
                    onChanged: (bool res) =>
                        editAlarmVM.switchAlarmOnValue(res),
                  ),
                  Expanded(child: SizedBox()),
                  FlatButton(
                    child: Text(
                      tf.getMilitaryTime(currentAlarm.ringTime),
                      style: Theme.of(context).textTheme.display1,
                    ),
                    onPressed: () async {
                      final newTime = await showTimePicker(
                        context: context,
                        initialTime:
                            TimeOfDay.fromDateTime(currentAlarm.ringTime),
                      );
                      if (newTime != null) {
                        this.editAlarmVM.setNewTime(newTime);
                      }
                    },
                  ),
                  Expanded(child: SizedBox()),
                  RaisedButton(
                      onPressed: () {
                        this.editAlarmVM.resetDefault(
                            this.homeVM.currentSchedule.getSelectedSegment());
                      },
                      child: Text(presenter.resetDefaultText,
                          style: Theme.of(context).textTheme.button)),
                  Expanded(child: SizedBox()),
                ],
              )
            ],
          ),
        );
        return container;
      },
    );
  }
}

class EditAlarmModalPresenter {
  final BuildContext _context;
  final EditAlarmViewModel _editAlarmViewModel;
  final HomeViewModel _homeViewModel;
  // AlarmInfo currentAlarm;
  SleepSegment selectedSegment;
  TimeFormatter tf = TimeFormatter();
  EditAlarmModalPresenter(
      this._context, this._editAlarmViewModel, this._homeViewModel) {
    // currentAlarm = _editAlarmViewModel.currentAlarm;
    selectedSegment = _homeViewModel.currentSchedule?.getSelectedSegment();
  }

  String get alarmHeaderText {
    if (_editAlarmViewModel.currentAlarm == null || selectedSegment == null)
      return "";
    return "Alarm for ${tf.getMilitaryTime(selectedSegment.startTime)} - ${tf.getMilitaryTime(selectedSegment.endTime)} nap";
  }

  String get alarmOnText {
    if (_editAlarmViewModel.currentAlarm == null || selectedSegment == null)
      return "";
    return (_editAlarmViewModel.currentAlarm.soundOn) ? "On" : "Off";
  }

  String get resetDefaultText => AppLocalizations.of(_context).resetDefault;

  String get saveText => AppLocalizations.of(_context).saveText;
}
