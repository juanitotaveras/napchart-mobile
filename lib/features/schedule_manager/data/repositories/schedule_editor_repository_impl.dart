import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:polysleep/core/error/exceptions.dart';
import 'package:polysleep/core/error/failure.dart';
import 'package:polysleep/features/schedule_manager/data/datasources/android_platform_source.dart';
import 'package:polysleep/features/schedule_manager/data/datasources/assets_data_source.dart';
import 'package:polysleep/features/schedule_manager/data/datasources/ios_platform_source.dart';
import 'package:polysleep/features/schedule_manager/data/datasources/preferences_data_source.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_schedule_model.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/domain/repositories/schedule_editor_repository.dart';
import 'package:meta/meta.dart';
import 'dart:io' show Platform;

class ScheduleRepositoryImpl implements ScheduleRepository {
  final PreferencesDataSource preferencesDataSource;
  final AssetsDataSource assetsDataSource;
  final AndroidPlatformSourceImpl androidPlatformSource;
  final IOSPlatformSourceImpl iOSPlatformSource;

  ScheduleRepositoryImpl(
      {@required this.preferencesDataSource,
      @required this.assetsDataSource,
      @required this.androidPlatformSource,
      @required this.iOSPlatformSource});
  // temporary
  getSegments() async {
    final segments = [
      SleepSegment(
          startTime: SegmentDateTime(hr: 10, min: 30, day: 0),
          endTime: SegmentDateTime(hr: 12, min: 0, day: 0))
    ];
    return segments;
  }

  @override
  Future<Either<Failure, SleepSchedule>> getCurrentSchedule() async {
    try {
      final SleepScheduleModel currentSchedule =
          await preferencesDataSource.getCurrentSchedule();
      return Right(currentSchedule);
    } on PreferencesException {
      return Left(PreferencesFailure());
    }
  }

  @override
  Future<Either<Failure, SleepSchedule>> getDefaultSchedule() async {
    try {
      final defaultSchedule = await assetsDataSource.getDefaultSchedule();
      return Right(defaultSchedule);
    } on AssetsException {
      return Left(AssetsFailure());
    }
  }

  @override
  Future<Either<Failure, void>> putCurrentSchedule(
      SleepSchedule schedule) async {
    try {
      final model = SleepScheduleModel.fromEntity(schedule);
      await preferencesDataSource.putCurrentSchedule(model);
      return Right(null);
    } on PreferencesException {
      return Left(PreferencesFailure());
    }
  }

  @override
  Future<Either<Failure, List<SleepSchedule>>> getScheduleTemplates() async {
    try {
      final scheduleTemplates = await assetsDataSource.getScheduleTemplates();
      return Right(scheduleTemplates);
    } on AssetsException {
      return Left(AssetsFailure());
    }
  }

  @override
  Future<Either<Failure, void>> setAlarm(AlarmInfo alarmInfo) async {
    // TODO: Create an onAlarmExecute function
    if (Platform.isAndroid) {
      try {
        await androidPlatformSource.setAlarm(alarmInfo);
        return Right(null);
      } on AndroidException {
        return Left(AndroidFailure());
      }
    } else if (Platform.isIOS) {
      try {
        await iOSPlatformSource.setAlarm(alarmInfo);
        return Right(null);
      } on IOSException {
        return Left(IOSFailure());
      }
    }
    return Left(GeneralFailure());
  }

  @override
  Future<Either<Failure, void>> deleteAlarm(AlarmInfo alarmInfo) async {
    if (Platform.isAndroid) {
      try {
        await androidPlatformSource.deleteAlarm(alarmInfo);
        return Right(null);
      } on AndroidException {
        return Left(AndroidFailure());
      }
    } else if (Platform.isIOS) {
      try {
        await iOSPlatformSource.deleteAlarm(alarmInfo);
        return Right(null);
      } on IOSException {
        return Left(IOSFailure());
      }
    }
    return Left(GeneralFailure());
  }
}
