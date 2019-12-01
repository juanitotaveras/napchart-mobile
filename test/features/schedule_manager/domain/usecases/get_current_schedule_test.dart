import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polysleep/core/usecases/usecase.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/domain/repositories/schedule_editor_repository.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/get_current_schedule.dart';

class MockScheduleEditorRepository extends Mock implements ScheduleRepository {}

void main() {
  GetCurrentSchedule usecase;
  MockScheduleEditorRepository mockScheduleEditorRepository;

  setUp(() {
    mockScheduleEditorRepository = MockScheduleEditorRepository();
    usecase = GetCurrentSchedule(mockScheduleEditorRepository);
  });
  final tSegments = [
    SleepSegment(
        startTime: SegmentDateTime(hr: 22), endTime: SegmentDateTime(hr: 6))
  ];
  final tSchedule = SleepSchedule(name: "Monophasic", segments: tSegments);

  test('should get current schedule from repository', () async {
    when(mockScheduleEditorRepository.getCurrentSchedule())
        .thenAnswer((_) async => Right(tSchedule));

    // act
    final result = await usecase(NoParams());

    expect(result, Right(tSchedule));

    verify(mockScheduleEditorRepository.getCurrentSchedule());

    verifyNoMoreInteractions(mockScheduleEditorRepository);
  });
}
