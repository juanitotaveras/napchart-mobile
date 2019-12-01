import 'package:dartz/dartz.dart';
import 'package:polysleep/core/error/failure.dart';
import 'package:polysleep/core/usecases/usecase.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/repositories/schedule_editor_repository.dart';

class LoadScheduleTemplates extends UseCase<List<SleepSchedule>, NoParams> {
  final ScheduleRepository repository;

  LoadScheduleTemplates(this.repository);

  @override
  Future<Either<Failure, List<SleepSchedule>>> call(NoParams params) async {
    return await repository.getScheduleTemplates();
  }
}
