import 'package:dartz/dartz.dart';
import 'package:polysleep/core/error/failure.dart';
import 'package:polysleep/core/usecases/usecase.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/repositories/schedule_editor_repository.dart';

import 'get_current_schedule.dart';
import 'get_default_schedule.dart';

class GetCurrentOrDefaultSchedule extends UseCase<SleepSchedule, NoParams> {
  final ScheduleEditorRepository repository;
  final GetCurrentSchedule getCurrentSchedule;
  final GetDefaultSchedule getDefaultSchedule;

  GetCurrentOrDefaultSchedule(
      this.repository, this.getCurrentSchedule, this.getDefaultSchedule);

  @override
  Future<Either<Failure, SleepSchedule>> call(NoParams params) async {
    final resp = await getCurrentSchedule(NoParams());
    return await resp.fold((failure) async {
      return await getDefaultSchedule(NoParams());
    }, (schedule) async {
      return resp;
    });
  }
}
