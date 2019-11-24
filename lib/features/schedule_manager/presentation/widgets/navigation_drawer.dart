import 'package:flutter/material.dart';

import '../localizations.dart';

class NavigationDrawerPresenter {}

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
      DrawerHeader(
        child: Text('Drawer Header'),
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
      ),
      ListTile(
          leading: Icon(Icons.home),
          title: Text(AppLocalizations.of(context).home),
          onTap: () {}),
      ListTile(
        title: Text(AppLocalizations.of(context).information),
        onTap: () {},
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).settings),
        onTap: () {},
      )
    ]));
  }
}
