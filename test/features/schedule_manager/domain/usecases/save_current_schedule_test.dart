import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:polysleep/features/schedule_manager/data/models/alarm_info_model.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/domain/repositories/platform_repository.dart';
import 'package:polysleep/features/schedule_manager/domain/repositories/schedule_editor_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/save_current_schedule.dart';

class MockPlatformRepository extends Mock implements PlatformRepository {}

class MockScheduleRepository extends Mock implements ScheduleRepository {}

void main() {
  SaveCurrentSchedule usecase;
  MockScheduleRepository mockScheduleEditorRepository;
  MockPlatformRepository mockPlatformRepository;
  final tSegments = [
    SleepSegment(
        startTime: SegmentDateTime(hr: 22),
        endTime: SegmentDateTime(hr: 4),
        alarmInfo:
            AlarmInfoModel.createDefaultUsingTime(SegmentDateTime(hr: 4))),
    SleepSegment(
        startTime: SegmentDateTime(hr: 12),
        endTime: SegmentDateTime(hr: 12, min: 30),
        alarmInfo: AlarmInfoModel.createDefaultUsingTime(
            SegmentDateTime(hr: 12, min: 30)),
        isSelected: true)
  ];
  final tSchedule = SleepSchedule(segments: tSegments);
  setUp(() {
    mockScheduleEditorRepository = MockScheduleRepository();
    mockPlatformRepository = MockPlatformRepository();
    usecase = SaveCurrentSchedule(mockScheduleEditorRepository);
  });

  test('saveCurrentSchedule shoudl always call repository.putCurrentSchedule',
      () {
    final params = Params(newSchedule: tSchedule, previousSchedule: tSchedule);
    usecase(params);
  });

  test('alarms must be cleared if they are set to be cleared', () {});
}
