import 'package:polysleep/core/error/exceptions.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_schedule_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:meta/meta.dart';

abstract class PreferencesDataSource {
  Future<SleepScheduleModel> getCurrentSchedule();
  Future<SleepScheduleModel> putCurrentSchedule(
      SleepScheduleModel currentSchedule);
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
  Future<SleepScheduleModel> putCurrentSchedule(
      SleepScheduleModel currentSchedule) async {
    // Will return Future<bool> - true is success, false is failure
    final success = await sharedPreferences.setString(
        CURRENT_SCHEDULE, json.encode(currentSchedule.toJson()));
    if (success) {
      // read new state
      final updatedJson = sharedPreferences.getString(CURRENT_SCHEDULE);
      if (updatedJson != null) {
        return Future.value(
            SleepScheduleModel.fromJson(json.decode(updatedJson)));
      } else {
        throw PreferencesException();
      }
    }
    throw PreferencesException();
  }
}
