import 'package:dartz/dartz.dart';
import 'package:polysleep/core/error/failure.dart';
import 'package:polysleep/features/schedule_manager/data/datasources/android_platform_source.dart';
import 'package:polysleep/features/schedule_manager/data/datasources/ios_platform_source.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';
import 'package:polysleep/features/schedule_manager/domain/repositories/platform_repository.dart';
import 'package:meta/meta.dart';
import 'package:polysleep/core/error/exceptions.dart';
import 'dart:io' show Platform;

class PlatformRepositoryImpl implements PlatformRepository {
  final AndroidPlatformSourceImpl androidPlatformSource;
  final IOSPlatformSourceImpl iOSPlatformSource;
  PlatformRepositoryImpl(
      {@required this.androidPlatformSource, @required this.iOSPlatformSource});

  @override
  Future<Either<Failure, void>> setAlarm(AlarmInfo alarmInfo) async {
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
