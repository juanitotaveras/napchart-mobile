import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/home_event.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/view_model_provider.dart';
import 'package:polysleep/features/schedule_manager/presentation/time_formatter.dart';
import '../widgets/navigation_drawer.dart';
import '../localizations.dart';
import 'schedule_editor.dart';
import '../widgets/base_schedule.dart';
import '../widgets/current_schedule_graphic.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/home_view_model.dart';
import '../../../../injection_container.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class BasicTimeField extends StatelessWidget {
  final format = DateFormat("HH:mm");
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text('Basic time field (${format.pattern})'),
      DateTimeField(
        format: format,
        onShowPicker: (context, currentValue) async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          return DateTimeField.convert(time);
        },
      ),
    ]);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final _bloc = sl<HomeViewModel>();
  void _goToSleepScheduleCreator(context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScheduleEditor()),
    );
    _bloc.onLoadSchedule();
  }

  Widget _buildPortrait(context) {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[currentSchedule(context), nextNapCard(context)],
        ),
      ),
    );
  }

  Widget _buildLandscape(context) {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // currentSchedule(context),
          ],
        ),
      ),
    );
  }

  // TODO: Add currently selected segment
  Widget currentSchedule(context) {
    return StreamBuilder<DateTime>(
        stream: _bloc.currentTime,
        initialData: DateTime.now(),
        builder: (context, currentTimeStream) {
          return StreamBuilder<SleepSchedule>(
              stream: _bloc.currentScheduleStream,
              initialData: null,
              builder: (context, currentScheduleStream) {
                return Expanded(
                    child: CurrentScheduleGraphic(
                  currentTime: currentTimeStream.data,
                  currentSchedule: currentScheduleStream.data,
                ));
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return ViewModelProvider(
      bloc: _bloc,
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () {
                _goToSleepScheduleCreator(context);
              },
              child: Text("EDIT"),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
        ),
        drawer: NavigationDrawer(),
        body: /*(isPortrait) ?*/ _buildPortrait(
            context) /*: _buildLandscape(context)*/,
      ),
    );
  }

  Widget nextNapCard(context) {
    return StreamBuilder<SleepSchedule>(
        stream: _bloc.currentScheduleStream,
        builder: (context, currentScheduleStream) {
          final model = _bloc; //ViewModelProvider.of<HomeViewModel>(context);
          if (_bloc.shouldShowNapNavigationArrows) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: 10.0),
                  onPressed: () {
                    _bloc.onLeftNapArrowTapped();
                  },
                ),
                Expanded(child: nextNapCardCentralSection()),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, size: 10.0),
                  onPressed: () {
                    _bloc.onRightNapArrowTapped();
                  },
                )
              ],
            );
          } else {
            return nextNapCardCentralSection();
          }
        });
  }

  Widget nextNapCardCentralSection() {
    SleepSegment selectedSegment = _bloc.currentSchedule.getSelectedSegment();
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
            Scaffold.of(context).showBottomSheet((context) => Container(
                  color: Colors.red,
                ));
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

  Widget polysleepInfoCard() {
    return Card(
        child: Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        ListTile(
          title: Text(AppLocalizations.of(context).shortPolysleepDescTitle),
          subtitle: Text(
              'Polyphasic sleep is the practice of sleeping more than once in a 24 hour period.'
              '\nIf you take naps, you\'re sleeping polyphasically.'),
        ),
        ButtonTheme.bar(
            child: ButtonBar(children: <Widget>[
          FlatButton(
            child: Text(AppLocalizations.of(context).dismissCaps),
            onPressed: () {
              /* */
            },
          ),
          FlatButton(
            child: Text('LEARN MORE'),
            onPressed: () {
              /* */
            },
          )
        ]))
      ]),
    ));
  }
}
