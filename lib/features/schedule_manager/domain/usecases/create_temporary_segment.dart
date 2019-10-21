/*
When user taps screen, temporary sleep segment of
30 min should be created.
*/
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:polysleep/core/error/failure.dart';
import 'package:polysleep/core/usecases/usecase.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';

import '../repositories/schedule_editor_repository.dart';
import 'package:meta/meta.dart';

class CreateTemporarySleepSegment extends UseCase<SleepSegment, Params> {
  final ScheduleEditorRepository repository;

  CreateTemporarySleepSegment(this.repository);

  @override
  Future<Either<Failure, SleepSegment>> call(Params params) async {
    return await repository.putTemporarySleepSegment(params.segment);
  }
}

class Params extends Equatable {
  final SleepSegment segment;
  Params({@required this.segment}) : super([segment]);
}
