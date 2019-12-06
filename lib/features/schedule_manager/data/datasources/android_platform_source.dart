import 'dart:async';
import 'dart:isolate';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:polysleep/core/error/exceptions.dart';
import 'package:polysleep/features/schedule_manager/data/datasources/platform_source.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'dart:math';

class AndroidPlatformSourceImpl implements PlatformSource {
  static const platform = const MethodChannel('polysleep/alarm');
  @override
  Future<void> setAlarm(AlarmInfo alarmInfo) async {
    if (alarmInfo.alarmCode == null) {
      throw AndroidException();
    }
    try {
      await AndroidAlarmManager.initialize();
      final bool success = await AndroidAlarmManager.periodic(
          Duration(days: 1), alarmInfo.alarmCode, executeAlarm,
          exact: true,
          wakeup: true,
          rescheduleOnReboot: true,
          startAt: alarmInfo.getTodayRingTime(DateTime.now()));
      if (!success) {
        throw AndroidException();
      }
    } on PlatformException catch (e) {
      throw AndroidException();
    }
  }

  @override
  Future<void> deleteAlarm(AlarmInfo alarmInfo) async {
    try {
      await AndroidAlarmManager.cancel(alarmInfo.alarmCode);
    } on PlatformException catch (_) {
      throw AndroidException();
    }
  }
}

void executeAlarm(int alarmCode) async {
  final int isolateId = Isolate.current.hashCode;
  // TODO: Need to access alarmInfo somehow to know
  // what sound to play and whether to vibrate or not.
  /*
Use this for a continuous alarm:
Stream.periodic(const Duration(milliseconds: 500))
      .take(10)
      .listen((_) => print('tick'));
  */
  if (await Vibration.hasVibrator()) {
    const waitTime = const Duration(milliseconds: 2000);
    vibrate(10, waitTime);
  }
}

void vibrate(int count, Duration waitTime) {
  if (count == 0) return;
  Timer(waitTime, () {
    print('execution');
    Vibration.vibrate(duration: 1000);
    vibrate(count - 1, waitTime);
  });
}
