import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:polysleep/core/error/failure.dart';
import 'package:polysleep/core/usecases/usecase.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/repositories/schedule_editor_repository.dart';
import 'package:meta/meta.dart';

class SetAlarm extends UseCase<void, Params> {
  final ScheduleRepository repository;
  SetAlarm(this.repository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    AlarmInfo alarmInfo = params.alarmInfo;
    Failure fail;
    if (!params.alarmInfo.isOn) {
      // delete alarm if it is off.
      final Either<Failure, void> result =
          await repository.deleteAlarm(alarmInfo);
      result.fold((failure) {
        fail = failure;
      }, (_) {});
      if (fail != null) return Left(fail);
    }
    if (params.alarmInfo.alarmCode == null) {
      // Generate a new alarmCode if this is a totally new alarm
      final newCode = _getNewAlarmCode(alarmInfo, params.schedule);
      alarmInfo = params.alarmInfo.clone(alarmCode: newCode);
    }

    final newSchedule = _createNewSchedule(alarmInfo, params.schedule);
    if (alarmInfo.soundOn || alarmInfo.vibrationOn) {
      // new alarm state should be "on"
      // This should also handle changing the alarm's time.
      final platformResult = await this.repository.setAlarm(alarmInfo);
      platformResult.fold((failure) {
        fail = failure;
      }, (_) async {
        final Either<Failure, void> result =
            await repository.putCurrentSchedule(newSchedule);
        result.fold((failure) {
          fail = failure;
        }, (_) {});
      });
    } else {
      // new alarm state should be "off", so do not set a new alarm.
      final Either<Failure, void> result =
          await repository.putCurrentSchedule(newSchedule);
      result.fold((failure) {
        fail = failure;
      }, (_) {});
    }

    return (fail != null) ? Left(fail) : Right(null);
  }

  SleepSchedule _createNewSchedule(
      AlarmInfo alarmInfo, SleepSchedule schedule) {
    final newSelectedSegment =
        schedule.getSelectedSegment().clone(alarmInfo: alarmInfo);
    final newSegments = schedule.segments
        .map((seg) => seg.isSelected ? newSelectedSegment : seg)
        .toList();
    final newSchedule = schedule.clone(segments: newSegments);
    return newSchedule;
  }

  int _getNewAlarmCode(AlarmInfo alarmInfo, SleepSchedule schedule) {
    final Set<int> numberSet = Set();

    schedule.segments.forEach((seg) {
      if (seg.alarmInfo.alarmCode != null) {
        numberSet.add(seg.alarmInfo.alarmCode);
      }
    });

    var newCode = 0;
    while (numberSet.contains(newCode)) ++newCode;
    return newCode;
  }
}

class Params extends Equatable {
  final AlarmInfo alarmInfo;
  final SleepSchedule schedule;
  Params({@required this.alarmInfo, @required this.schedule})
      : super([alarmInfo]);
}
