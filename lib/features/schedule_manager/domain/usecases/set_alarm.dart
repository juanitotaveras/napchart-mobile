import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:polysleep/core/error/failure.dart';
import 'package:polysleep/core/usecases/usecase.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/repositories/schedule_editor_repository.dart';
import 'package:meta/meta.dart';

class SetAlarm extends UseCase<bool, Params> {
  final ScheduleEditorRepository repository;
  SetAlarm(this.repository);

  // TODO: If setAlarm succeeds, we need to save it to our Preferences.

  @override
  Future<Either<Failure, bool>> call(Params params) async {
    final Either<Failure, bool> success =
        await repository.setAlarm(params.ringTime);
    success.fold((failure) {
      return Left(failure);
    }, (success) async {
      final currentScheduleResp = await repository.getCurrentSchedule();

      currentScheduleResp.fold((failure) {}, (SleepSchedule schedule) {
        // final newSchedule = schedule.clone(segments: )
      });
      // final newSchedule = currentSchedule.cl

      // TODO: We need to alter CurrentSchedule to use the new alarmInfo
      final Either<Failure, SleepSchedule> res =
          await repository.putCurrentSchedule(params.schedule);
      return res;
    });
    return null; // TODO: Inspect this. Should not need this but compiler is complaining.
  }
}

class Params extends Equatable {
  final DateTime ringTime;
  final SleepSchedule schedule;
  Params({@required this.ringTime, @required this.schedule})
      : super([ringTime]);
}
