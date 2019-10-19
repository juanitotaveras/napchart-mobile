import 'package:dartz/dartz.dart';
import 'package:polysleep/core/error/exceptions.dart';
import 'package:polysleep/core/error/failure.dart';
import 'package:polysleep/features/schedule_manager/data/datasources/preferences_data_source.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_schedule_model.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/domain/repositories/schedule_editor_repository.dart';
import 'package:meta/meta.dart';

class ScheduleEditorRepositoryImpl implements ScheduleEditorRepository {
  final PreferencesDataSource preferencesDataSource;
  ScheduleEditorRepositoryImpl({@required this.preferencesDataSource});
  // temporary
  getSegments() async {
    final segments = [
      SleepSegment(
          startTime: SegmentDateTime(hr: 10, min: 30, day: 0),
          endTime: SegmentDateTime(hr: 12, min: 0, day: 0))
    ];
    return segments;
  }

  @override
  Future<Either<Failure, SleepSchedule>> getCurrentSchedule() async {
    try {
      final currentSchedule = await preferencesDataSource.getCurrentSchedule();
      return Right(currentSchedule);
    } on PreferencesException {
      return Left(PreferencesFailure());
    }
  }

  @override
  Future<Either<Failure, SleepSegment>> putTemporarySleepSegment(
      SleepSegment segment) {
    // TODO: implement putTemporarySleepSegment
    return null;
  }
}
