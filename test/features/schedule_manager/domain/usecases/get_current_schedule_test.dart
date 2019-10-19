import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/domain/repositories/schedule_editor_repository.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/get_current_schedule.dart';

class MockScheduleEditorRepository extends Mock
    implements ScheduleEditorRepository {}

void main() {
  GetCurrentSchedule usecase;
  MockScheduleEditorRepository mockScheduleEditorRepository;

  setUp(() {
    mockScheduleEditorRepository = MockScheduleEditorRepository();
    usecase = GetCurrentSchedule(mockScheduleEditorRepository);
  });

  final loadedSegments = [
    SleepSegment(
        startTime: SegmentDateTime(hr: 1, min: 0),
        endTime: SegmentDateTime(hr: 2, min: 0))
  ];
  test('should get current schedule from repository', () async {
    when(mockScheduleEditorRepository.getCurrentSchedule())
        .thenAnswer((_) async => Right(loadedSegments));

    // act
    final result = await usecase(Params(segmentList: loadedSegments));

    expect(result, Right(loadedSegments));

    verify(mockScheduleEditorRepository.getCurrentSchedule());

    verifyNoMoreInteractions(mockScheduleEditorRepository);
  });
}
