import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/sleep_segment.dart';

abstract class ScheduleEditorRepository {
  Future<Either<Failure, SleepSegment>> putTemporarySleepSegment(
      SleepSegment segment);
}
