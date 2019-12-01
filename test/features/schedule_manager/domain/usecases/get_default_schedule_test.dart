import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polysleep/core/usecases/usecase.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/domain/repositories/schedule_editor_repository.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/get_current_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/get_default_schedule.dart';
import 'package:mockito/mockito.dart';

class MockScheduleEditorRepository extends Mock implements ScheduleRepository {}

void main() {
  GetDefaultSchedule usecase;
  MockScheduleEditorRepository mockScheduleEditorRepository;

  setUp(() {
    mockScheduleEditorRepository = MockScheduleEditorRepository();
    usecase = GetDefaultSchedule(mockScheduleEditorRepository);
  });
  final tSegments = [
    SleepSegment(
        startTime: SegmentDateTime(hr: 22), endTime: SegmentDateTime(hr: 6))
  ];
  final tSchedule = SleepSchedule(name: "Monophasic", segments: tSegments);

  test('should get default schedule from repository', () async {
    when(mockScheduleEditorRepository.getDefaultSchedule())
        .thenAnswer((_) async => Right(tSchedule));

    // act
    final result = await usecase(NoParams());

    expect(result, Right(tSchedule));

    verify(mockScheduleEditorRepository.getDefaultSchedule());

    verifyNoMoreInteractions(mockScheduleEditorRepository);
  });
}
