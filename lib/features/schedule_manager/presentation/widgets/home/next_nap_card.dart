import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/home_event.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/view_model_provider.dart';
import 'package:polysleep/features/schedule_manager/presentation/time_formatter.dart';
import '../../localizations.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/home_view_model.dart';
import 'package:intl/intl.dart';

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
    return Card(
        child: Column(
      children: <Widget>[
        // ListTile(
        //   title: Text('Nap will last 5h20m'),
        //   subtitle: Text('22:00-6:00'),
        // ),
        Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Column(
                  children: <Widget>[
                    Text('Start'),
                    Text(tf.getMilitaryTime(selectedSegment.startTime))
                  ],
                )),
                Expanded(
                    child: Column(
                  children: <Widget>[
                    Text('End'),
                    Text(tf.getMilitaryTime(selectedSegment.endTime))
                  ],
                )),
                Expanded(
                    child: Column(
                  children: <Widget>[
                    Text('Duration'),
                    Text(tf
                        .formatSleepTime(selectedSegment.getDurationMinutes()))
                  ],
                )),
              ],
            )),
        ListTile(
          title: Text('Alarm'),
          leading: Icon(Icons.alarm_on),
          subtitle: Text('Set for 5:00am'),
          onTap: () async {
            print('el chapo');
            showModalBottomSheet(
                context: ctxt, builder: (context) => EditAlarmModal(vm));
            // Scaffold.of(ctxt).showBottomSheet((context) => EditAlarmModal());
            // await showTimePicker(
            //     context: context,
            //     initialTime: TimeOfDay.fromDateTime(DateTime.now()));
          },
        ),
        // BasicTimeField(),
        ListTile(
            title: Text('Notifications'),
            leading: Icon(Icons.notifications_active)),
      ],
    ));
  }
}

class EditAlarmModal extends StatelessWidget {
  final HomeViewModel vm;
  EditAlarmModal(this.vm);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final mediaQueryData = MediaQuery.of(context);
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
                onPressed: () {},
              ),
              Expanded(
                child: Container(),
              ),
              FlatButton(
                child: Text('Save'),
                onPressed: () {},
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Icon(Icons.alarm),
              Expanded(child: Text('Alarm for 22:00 - 6:00 nap'))
            ],
          ),
          Row(
            children: <Widget>[
              Text('On'),
              Switch(
                value: true,
                onChanged: (bool res) => res,
              )
            ],
          )
        ],
      ),
    );
    // return container;
    // return StreamBuilder<
  }
}
