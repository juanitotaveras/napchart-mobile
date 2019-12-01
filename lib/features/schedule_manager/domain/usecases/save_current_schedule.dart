import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_schedule_model.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/repositories/schedule_editor_repository.dart';
import '../repositories/schedule_editor_repository.dart';
import 'package:meta/meta.dart';
import 'package:polysleep/core/error/failure.dart';
import 'package:polysleep/core/usecases/usecase.dart';

class SaveCurrentSchedule extends UseCase<void, Params> {
  final ScheduleRepository repository;

  SaveCurrentSchedule(this.repository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    // TODO: We should compare new schedule with initial schedule.
    // If we delete alarms, they must be cleared from the platform.
    return await repository.putCurrentSchedule(params.newSchedule);
  }
}

class Params extends Equatable {
  final SleepSchedule newSchedule;
  final SleepSchedule previousSchedule;
  Params({@required this.newSchedule, @required this.previousSchedule})
      : super([newSchedule, previousSchedule]);
}
