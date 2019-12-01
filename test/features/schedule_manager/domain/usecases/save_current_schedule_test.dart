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
  MockScheduleRepository mockScheduleRepository;
  MockPlatformRepository mockPlatformRepository;
  final tAlarmInfo = AlarmInfo(
      ringTime: SegmentDateTime(hr: 4),
      soundOn: true,
      vibrationOn: true,
      alarmCode: 2);
  final tSegments = [
    SleepSegment(
        startTime: SegmentDateTime(hr: 22),
        endTime: SegmentDateTime(hr: 4),
        alarmInfo: tAlarmInfo),
    SleepSegment(
        startTime: SegmentDateTime(hr: 12),
        endTime: SegmentDateTime(hr: 12, min: 30),
        alarmInfo: AlarmInfoModel.createDefaultUsingTime(
            SegmentDateTime(hr: 12, min: 30)),
        isSelected: true)
  ];
  final tSchedule = SleepSchedule(segments: tSegments);
  setUp(() {
    mockScheduleRepository = MockScheduleRepository();
    mockPlatformRepository = MockPlatformRepository();
    usecase =
        SaveCurrentSchedule(mockScheduleRepository, mockPlatformRepository);
  });

  test('saveCurrentSchedule should always call repository.putCurrentSchedule',
      () {
    // arrange
    final params = Params(newSchedule: tSchedule, previousSchedule: tSchedule);

    // act
    usecase(params);

    //assert
    verify(mockScheduleRepository.putCurrentSchedule(tSchedule));
  });

  test('alarms must be cleared if they are set to be cleared', () {
    // arrange

    // this alarm is being cancelled
    final newAlarmInfo = AlarmInfo(
        ringTime: SegmentDateTime(hr: 4),
        soundOn: false,
        vibrationOn: false,
        alarmCode: 2);
    final newSegments = [
      SleepSegment(
          startTime: SegmentDateTime(hr: 22),
          endTime: SegmentDateTime(hr: 4),
          alarmInfo: newAlarmInfo),
      SleepSegment(
          startTime: SegmentDateTime(hr: 12),
          endTime: SegmentDateTime(hr: 12, min: 30),
          alarmInfo: AlarmInfoModel.createDefaultUsingTime(
              SegmentDateTime(hr: 12, min: 30)),
          isSelected: true)
    ];
    final newSchedule = SleepSchedule(segments: newSegments);
    final params =
        Params(newSchedule: newSchedule, previousSchedule: tSchedule);

    // act
    usecase(params);

    // assert
    verify(mockPlatformRepository.deleteAlarm(newAlarmInfo)).called(1);
    verify(mockScheduleRepository.putCurrentSchedule(newSchedule));
  });
}
