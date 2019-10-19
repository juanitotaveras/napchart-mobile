// should get current schedule from repository
// return None if it has not been set
// return some schedule object if it has been set
import 'package:dartz/dartz.dart';
import 'package:polysleep/core/error/failure.dart';
import 'package:polysleep/core/usecases/usecase.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:meta/meta.dart';

import '../repositories/schedule_editor_repository.dart';

class GetCurrentSchedule extends UseCase<SleepSchedule, NoParams> {
  final ScheduleEditorRepository repository;

  GetCurrentSchedule(this.repository);

  @override
  Future<Either<Failure, SleepSchedule>> call(NoParams params) async {
    return await repository.getCurrentSchedule();
  }
}
