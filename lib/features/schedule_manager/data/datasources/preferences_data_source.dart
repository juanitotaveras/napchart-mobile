import 'package:polysleep/core/error/exceptions.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_schedule_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:meta/meta.dart';

abstract class PreferencesDataSource {
  Future<SleepScheduleModel> getCurrentSchedule();
  Future<void> putCurrentSchedule(SleepScheduleModel currentSchedule);
}

const CURRENT_SCHEDULE = 'CURRENT_SCHEDULE';

class PreferencesDataSourceImpl implements PreferencesDataSource {
  final SharedPreferences sharedPreferences;

  PreferencesDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<SleepScheduleModel> getCurrentSchedule() {
    final jsonString = sharedPreferences.getString(CURRENT_SCHEDULE);
    if (jsonString != null) {
      return Future.value(SleepScheduleModel.fromJson(json.decode(jsonString)));
    } else {
      throw PreferencesException();
    }
  }

  @override
  Future<void> putCurrentSchedule(SleepScheduleModel currentSchedule) {
    return sharedPreferences.setString(
        CURRENT_SCHEDULE, json.encode(currentSchedule.toJson()));
  }
}
