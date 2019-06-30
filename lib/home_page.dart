import 'package:flutter/material.dart';
import 'navigation_drawer.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

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

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      drawer: NavigationDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Card(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          const ListTile(
                            leading: Icon(Icons.info),
                            title: Text('What is polyphasic sleep?'),
                            subtitle: Text('Polyphasic sleep is the practice of breaking up your '
                                'sleep into smaller blocks placed throughout the day.'
                                '\nInspired by the siesta popular in Spain and segmented sleep'
                                ' which was widely practiced before artificial light '
                                'became the norm, polyphasic sleep can reduce the'
                                ' total sleep time required, help reduce constant tiredness,'
                                ' or help shift workers deal with demanding work schedules.'),
                          ),
                          ButtonTheme.bar(
                              child: ButtonBar(
                                  children: <Widget>[
                                    FlatButton(
                                      child: const Text('LEARN MORE'),
                                      onPressed: () {
                                        /* */
                                      },
                                    ),
                                    FlatButton(
                                      child: const Text('DISMISS'),
                                      onPressed: () {
                                        /* */
                                      },
                                    )
                                  ]
                              )
                          )
                        ]
                    ),
                  )
              ),
            ],
          ),
        ),

      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _incrementCounter,
        icon: Icon(Icons.create),
        label: Text('Create sleep schedule'),
      ),
    );
  }
}
