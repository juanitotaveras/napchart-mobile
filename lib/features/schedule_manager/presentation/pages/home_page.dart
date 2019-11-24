import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/view_models/view_model_provider.dart';
import 'package:polysleep/features/schedule_manager/presentation/time_formatter.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/home/next_nap_card.dart';
import '../widgets/navigation_drawer.dart';
import '../localizations.dart';
import 'schedule_editor.dart';
import '../widgets/current_schedule_graphic.dart';
import 'package:polysleep/features/schedule_manager/presentation/view_models/home_view_model.dart';
import '../../../../injection_container.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatelessWidget {
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
          children: <Widget>[currentSchedule(context), NextNapCard(_bloc)],
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
          title: Text('My Schedule'),
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
}

class PolysleepInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
