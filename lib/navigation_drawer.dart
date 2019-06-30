import 'package:flutter/material.dart';
import 'localizations.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                  leading: Icon(Icons.home),
                  title: Text(AppLocalizations.of(context).home),
                  onTap: () {

                  }
              ),
              ListTile(
                leading: Icon(Icons.create),
                title: Text('Schedule creator'),
                onTap: () {
                  // update app status
                },
              ),
              ListTile(
                title: Text('Alarm settings'),
                onTap: () {

                },
              ),
              ListTile(
                  title: Text('Sleep diary'),
                  onTap: () {

                  }
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).information),
                onTap: () {

                },
              ),
              ListTile(
                  title: Text('Get premium'),
                  onTap: () {

                  }
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).settings),
                onTap: () {

                },
              )
            ]
        )
    );
  }

}