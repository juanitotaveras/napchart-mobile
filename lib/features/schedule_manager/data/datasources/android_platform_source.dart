import 'dart:async';

import 'package:flutter/material.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/view_models/view_model_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class AndroidPlatformSource {
  Future<bool> setAlarm(DateTime ringTime);
}

class AndroidPlatformSourceImpl implements AndroidPlatformSource {
  static const platform = const MethodChannel('polysleep/alarm');
  @override
  Future<bool> setAlarm(DateTime ringTime) async {
    try {
      final String success = await platform.invokeMethod(
          'setAlarm', ringTime.millisecondsSinceEpoch);
      return success == 'success';
    } on PlatformException catch (e) {}
    return null;
  }
}
