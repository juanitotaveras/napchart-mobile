import 'package:flutter/material.dart';

import 'navigation_drawer.dart';
import 'home_page.dart';

class SleepScheduleCreatorOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      body: /*Container(
          child: ListView(children: <Widget>[
        Card(
          child: ListTile(
              title: Text('Everyman 3'), subtitle: Text('difficulty: medium')),
        ),
      ])),
    )*/
      Center(
        child: CustomPaint(
          painter: BaseSchedulePainter(),
          child: Text("test")
    ),
      ));
  }
}
