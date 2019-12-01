import 'package:dartz/dartz.dart';
import 'package:polysleep/core/error/failure.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';

abstract class PlatformRepository {
  Future<Either<Failure, void>> setAlarm(AlarmInfo alarmInfo);
  Future<Either<Failure, void>> deleteAlarm(AlarmInfo alarmInfo);
}
