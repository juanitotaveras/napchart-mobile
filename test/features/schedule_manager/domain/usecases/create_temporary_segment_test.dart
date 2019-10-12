import 'package:dartz/dartz.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/domain/repositories/schedule_editor_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/create_temporary_segment.dart';

class MockScheduleEditorRepository extends Mock
    implements ScheduleEditorRepository {}

void main() {
  CreateTemporarySleepSegment usecase;
  MockScheduleEditorRepository mockScheduleEditorRepository;

  setUp(() {
    mockScheduleEditorRepository = MockScheduleEditorRepository();
    usecase = CreateTemporarySleepSegment(mockScheduleEditorRepository);
  });
  final tSegment =
      SleepSegment(startTime: DateTime(2020), endTime: DateTime(2021));

  test('should put temporary sleep segment in repository', () async {
    when(mockScheduleEditorRepository.putTemporarySleepSegment(any))
        .thenAnswer((_) async => Right(tSegment));

    // act
    final result = await usecase(Params(segment: tSegment));

    expect(result, Right(tSegment));

    verify(mockScheduleEditorRepository.putTemporarySleepSegment(tSegment));

    verifyNoMoreInteractions(mockScheduleEditorRepository);
  });
}
