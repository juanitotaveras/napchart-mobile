import 'dart:convert';

import 'package:polysleep/core/error/exceptions.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_schedule_model.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show AssetBundle;
import 'package:meta/meta.dart';

abstract class AssetsDataSource {
  Future<SleepScheduleModel> getDefaultSchedule();
}

const DEFAULT_SCHEDULE_NAME = 'monophasic.json';
const TEMPLATES_FOLDER_PATH = 'assets/schedule_templates';

class AssetsDataSourceImpl implements AssetsDataSource {
  final AssetBundle rootBundle;
  AssetsDataSourceImpl({@required this.rootBundle});
  @override
  Future<SleepScheduleModel> getDefaultSchedule() async {
    try {
      final res = await rootBundle
          .loadString('$TEMPLATES_FOLDER_PATH/$DEFAULT_SCHEDULE_NAME');
      final Map<String, dynamic> jsonObj = json.decode(res);
      print('all is good');

      return Future.value(SleepScheduleModel.fromJson(jsonObj));
    } catch (exp) {
      print(exp);
      throw AssetsException();
    }
  }
}
