/*
When user taps screen, temporary sleep segment of
30 min should be created.
*/
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:polysleep/core/error/failure.dart';
import 'package:polysleep/core/usecases/usecase.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/bloc.dart';

import '../repositories/schedule_editor_repository.dart';
import 'package:meta/meta.dart';

class CreateTemporarySleepSegment /*extends UseCase<SleepSchedule, Params>*/ {
  // final ScheduleEditorRepository repository;

  // CreateTemporarySleepSegment(this.repository);

  // @override
  // Future<Either<Failure, SleepSchedule>> call(Params params) async {
  //   // We also need our SleepSchedule as the current state
  //   // we should make a copy of our current state and return that
  //   return Right(
  //       SleepSchedule(segments: [], name: params.currentSchedule.name));
  // }

  SegmentsLoaded call(SegmentsLoaded currentState, DateTime startTime) {
    DateTime endTime = startTime.add(Duration(minutes: 60));
    SleepSegment selectedSegment =
        SleepSegment(startTime: startTime, endTime: endTime);
    return SegmentsLoaded(
        selectedSegment: selectedSegment,
        loadedSegments: [...currentState.loadedSegments]);
  }
}

// class Params extends Equatable {
//   final SleepSegment segment;
//   final SleepSchedule currentSchedule;
//   Params({@required this.segment, @required this.currentSchedule})
//       : super([segment, currentSchedule]);
// }
