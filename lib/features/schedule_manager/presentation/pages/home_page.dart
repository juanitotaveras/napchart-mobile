import 'package:flutter/material.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/home_event.dart';
import '../widgets/navigation_drawer.dart';
import '../localizations.dart';
import 'schedule_editor.dart';
import '../widgets/base_schedule.dart';
import '../widgets/current_schedule_graphic.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/time.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/home_bloc.dart';
import '../../../../injection_container.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  // TODO: Get current schedule from repository when we get here
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  // final _bloc = HomeBloc();
  final _bloc = sl<HomeBloc>();
  void _goToSleepScheduleCreator(context) async {
    // TODO: Use await, and refresh our Bloc when we come back
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScheduleEditor()),
    );
    print('result: $result');
    // TODO: Let's refresh our Bloc here
    _bloc.dispatch(LoadCurrentSchedule());
  }

  Widget _buildPortrait(context) {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            currentSchedule(context),
            Card(
                child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                ListTile(
                  title: Text(
                      AppLocalizations.of(context).shortPolysleepDescTitle),
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
            )),
          ],
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

  Widget currentSchedule(context) {
    return StreamBuilder<DateTime>(
        stream: _bloc.currentTime,
        initialData: DateTime.now(),
        builder: (context, currentTimeStream) {
          return StreamBuilder<SleepSchedule>(
              stream: _bloc.viewModel.currentScheduleStream,
              initialData: null,
              builder: (context, currentScheduleStream) {
                return Expanded(
                    child: CurrentScheduleGraphic(
                  currentTime: currentTimeStream.data,
                  currentSchedule: currentScheduleStream.data,
                ) //BaseScheduleGraphic()
                    );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      drawer: NavigationDrawer(),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: /*(isPortrait) ?*/ _buildPortrait(
          context) /*: _buildLandscape(context)*/,
//      floatingActionButton: FloatingAction
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goToSleepScheduleCreator(context),
        child: Icon(Icons.create),
//        icon: Icon(Icons.create),
//        label: Text(AppLocalizations.of(context).createSleepSchedule),
      ),
    );
  }
}
