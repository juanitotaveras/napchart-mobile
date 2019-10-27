import 'dart:convert';

import 'package:polysleep/core/error/exceptions.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_schedule_model.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show AssetBundle;
import 'package:meta/meta.dart';

abstract class AssetsDataSource {
  Future<SleepScheduleModel> getDefaultSchedule();
  Future<List<SleepScheduleModel>> getScheduleTemplates();
}

const DEFAULT_SCHEDULE_NAME = 'monophasic.json';
const TEMPLATES_FOLDER_PATH = 'assets/schedule_templates';
const SCHEDULES_LIST = ['monophasic.json', 'biphasic.json'];

class AssetsDataSourceImpl implements AssetsDataSource {
  final AssetBundle rootBundle;
  AssetsDataSourceImpl({@required this.rootBundle});
  @override
  Future<SleepScheduleModel> getDefaultSchedule() async {
    try {
      final res = await rootBundle
          .loadString('$TEMPLATES_FOLDER_PATH/$DEFAULT_SCHEDULE_NAME');
      final Map<String, dynamic> jsonObj = json.decode(res);

      return Future.value(SleepScheduleModel.fromJson(jsonObj));
    } catch (exp) {
      print(exp);
      throw AssetsException();
    }
  }

  @override
  Future<List<SleepScheduleModel>> getScheduleTemplates() async {
    final List<SleepScheduleModel> templates = [];
    try {
      SCHEDULES_LIST.forEach((fileName) async {
        final res =
            await rootBundle.loadString('$TEMPLATES_FOLDER_PATH/$fileName');
        final Map<String, dynamic> jsonObj = json.decode(res);
        final sched = SleepScheduleModel.fromJson(jsonObj);
        templates.add(sched);
      });
    } catch (exp) {
      print(exp);
      throw AssetsException();
    }
    return Future.value(templates);
  }
}
