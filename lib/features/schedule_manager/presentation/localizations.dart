import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'l10n/messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get title {
    return Intl.message('Hello World', name: 'title');
  }

  String get home {
    return Intl.message('My schedule', name: 'home');
  }

  String get settings {
    return Intl.message('Settings', name: 'settings');
  }

  String get information {
    return Intl.message('Information', name: 'information');
  }

  String get shortPolysleepDescTitle {
    return Intl.message('What is polyphasic sleep?',
        name: 'shortPolysleepDescTitle');
  }

  String get dismissCaps {
    return Intl.message('DISMISS', name: 'dismissCaps');
  }

  String get createSleepSchedule {
    return Intl.message('Create sleep schedule', name: 'createSleepSchedule');
  }

  String get awakeStart => Intl.message('Awake: ', name: 'awake');

  String get asleepStart => Intl.message('Asleep: ', name: 'asleep');

  String get chooseScheduleButtonText =>
      Intl.message('Choose Schedule', name: 'chooseSchedule');

  String get chooseTemplatePageHeader =>
      Intl.message('Choose a template', name: 'chooseTemplate');
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
    //return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
