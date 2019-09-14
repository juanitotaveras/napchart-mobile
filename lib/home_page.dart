import 'package:flutter/material.dart';
import 'navigation_drawer.dart';
import 'localizations.dart';
import 'sleep_schedule_creator_1.dart';
import 'base_schedule.dart';
import 'current_schedule_graphic.dart';
import 'package:polysleep/src/models/time.dart';
import 'package:polysleep/src/blocs/home_bloc.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final _bloc = HomeBloc();

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _goToSleepScheduleCreator() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SleepScheduleCreatorOne()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      drawer: NavigationDrawer(),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: StreamBuilder<Object>(
        stream: bloc.currentTime,
        initialData: DateTime.now(),
        builder: (context, snapshot) {
          return Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
//              Container(
//                child: BaseScheduleGraphic(),
//                width: 350,
//              ),
                  Expanded(
                    child: CurrentScheduleGraphic(currentTime: snapshot.data)//BaseScheduleGraphic()
                  )

//              Card(
//                  child: Padding(
//                    padding: const EdgeInsets.only(top: 16.0),
//                    child: Column(
//                        mainAxisSize: MainAxisSize.min,
//                        children: <Widget>[
//                          ListTile(
//                            title: Text(AppLocalizations.of(context).shortPolysleepDescTitle),
//                            subtitle: Text('Polyphasic sleep is the practice of sleeping more than once in a 24 hour period.'
//                                '\nIf you take naps, you\'re sleeping polyphasically.'),
//                          ),
//                          ListTile(
//                            title: Text('Why do people do it?'),
//                            subtitle: Text(
//                                'Inspired by the mid-day nap popular in Spain and segmented sleep'
//                                ' which was the norm before artificial light '
//                                'became widespread, polyphasic sleep can reduce the'
//                                ' total sleep time required, help reduce constant tiredness,'
//                                ' or help shift workers deal with demanding work schedules.'),
//                          ),
//                          ListTile(
//                            title: Text('What is this app for?'),
//                            subtitle: Text(
//                                'PolySleep was created to help people learn about various'
//                                    ' established polyphasic sleep schedules and provides tools to help you'
//                                    ' choose and adapt to the right schedule for you.'),
//                          ),
//                          ButtonTheme.bar(
//                              child: ButtonBar(
//                                  children: <Widget>[
//                                    FlatButton(
//                                      child: Text(AppLocalizations.of(context).dismissCaps),
//                                      onPressed: () {
//                                        /* */
//                                      },
//                                    ),
//                                    FlatButton(
//                                      child: Text('LEARN MORE'),
//                                      onPressed: () {
//                                        /* */
//                                      },
//                                    )
//                                  ]
//                              )
//                          )
//                        ]
//                    ),
//                  )
//              ),
//              Expanded(
//                child: BaseScheduleGraphic()
//              )
//              Container(
//                child: BaseScheduleGraphic(),
//                height: 200,
//              ),

//              CustomPaint(
//                painter: BaseSchedulePainter()
//              ),
                ],
              ),
            ),

          );
        }
      ),
//      floatingActionButton: FloatingAction
      floatingActionButton: FloatingActionButton(
        onPressed: _goToSleepScheduleCreator,
        child: Icon(Icons.create),
//        icon: Icon(Icons.create),
//        label: Text(AppLocalizations.of(context).createSleepSchedule),
      ),
    );
  }
}
