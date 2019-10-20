import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_schedule_model.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/repositories/schedule_editor_repository.dart';
import '../repositories/schedule_editor_repository.dart';
import 'package:meta/meta.dart';
import 'package:polysleep/core/error/failure.dart';
import 'package:polysleep/core/usecases/usecase.dart';

class SaveCurrentSchedule extends UseCase<SleepSchedule, Params> {
  final ScheduleEditorRepository repository;

  SaveCurrentSchedule(this.repository);

  @override
  Future<Either<Failure, SleepSchedule>> call(Params params) async {
    final schedule = await repository.putCurrentSchedule(params.schedule);
    return schedule;
  }
}

class Params extends Equatable {
  final SleepSchedule schedule;
  Params({@required this.schedule}) : super([schedule]);
}
