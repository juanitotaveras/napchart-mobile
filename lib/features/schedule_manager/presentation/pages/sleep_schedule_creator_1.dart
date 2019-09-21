import 'package:flutter/material.dart';
import '../widgets/schedule_number_painter.dart';
import '../widgets/base_schedule.dart';

import '../widgets/navigation_drawer.dart';
import 'home_page.dart';

class SleepScheduleCreatorOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    return Container(
//      child: BaseScheduleGraphic()
//    );
    return Scaffold(
        appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            automaticallyImplyLeading: true,
            //`true` if you want Flutter to automatically add Back Button when needed,
            //or `false` if you want to force your own back button every where
            title: Text('Pick a schedule to start with'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )),
        //drawer: NavigationDrawer(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
//          Expanded(
//            child: BaseScheduleGraphic(),
//          )
            BaseScheduleGraphic()
          ],
        ));
  }
}
