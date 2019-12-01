import 'package:dartz/dartz.dart';
import 'package:polysleep/core/error/failure.dart';
import 'package:polysleep/core/usecases/usecase.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/repositories/schedule_editor_repository.dart';

class GetDefaultSchedule extends UseCase<SleepSchedule, NoParams> {
  final ScheduleRepository repository;

  GetDefaultSchedule(this.repository);

  @override
  Future<Either<Failure, SleepSchedule>> call(NoParams params) async {
    return await repository.getDefaultSchedule();
  }
}
