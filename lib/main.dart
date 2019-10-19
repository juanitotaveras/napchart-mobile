import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './features/schedule_manager/presentation/pages/home_page.dart';
import './features/schedule_manager/presentation/localizations.dart';
import 'injection_container.dart' as di;

void main() async {
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PolySleep',
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('en', ''), // English
        const Locale('es', '') // Spanish
      ],
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).title,
      theme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.dark,
        accentColor: Colors.redAccent,
      ),
      home: MyHomePage(title: 'My Schedule'),
    );
  }
}
