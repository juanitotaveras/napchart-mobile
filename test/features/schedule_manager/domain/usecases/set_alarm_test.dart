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
import 'package:polysleep/features/schedule_manager/domain/usecases/set_alarm.dart';

class MockPlatformRepository extends Mock implements PlatformRepository {}

class MockScheduleEditorRepository extends Mock
    implements ScheduleEditorRepository {}

void main() {
  SetAlarm usecase;
  MockScheduleEditorRepository mockScheduleEditorRepository;
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
    mockScheduleEditorRepository = MockScheduleEditorRepository();
    mockPlatformRepository = MockPlatformRepository();
    usecase = SetAlarm(mockScheduleEditorRepository, mockPlatformRepository);
    when(mockPlatformRepository.setAlarm(any))
        .thenAnswer((_) async => Right(null));
    when(mockPlatformRepository.deleteAlarm(any))
        .thenAnswer((_) async => Right(null));
  });

  test(
      'If we are changing the time of an alarm that is already on, delte current alarm and re-create',
      () async {});

  test(
      "If we are creating a new alarm that did not exist before, just generate a new alarmCode for it. (in this case, no other alarms are set)",
      () async {
    // arrange
    final ringTime = SegmentDateTime(hr: 12, min: 30);
    final params = Params(
        alarmInfo:
            AlarmInfo(soundOn: true, ringTime: ringTime, vibrationOn: false),
        schedule: tSchedule);
    when(mockScheduleEditorRepository.putCurrentSchedule(any))
        .thenAnswer((_) async => Right(null));
    // act
    usecase(params);

    // assert
    await untilCalled(mockScheduleEditorRepository.putCurrentSchedule(any));

    verify(mockPlatformRepository.setAlarm(AlarmInfo(
        ringTime: ringTime, soundOn: true, vibrationOn: false, alarmCode: 0)));
  });

  test(
      "If we are creating a new alarm that did not exist before, just generate a new alarmCode for it. (in this case, another alarm is set and we need to make sure alarmCodes are unique.)",
      () async {
    // arrange
    final tSegments = [
      SleepSegment(
          startTime: SegmentDateTime(hr: 22),
          endTime: SegmentDateTime(hr: 4),
          alarmInfo: AlarmInfo(
              ringTime: SegmentDateTime(hr: 4),
              soundOn: true,
              vibrationOn: true,
              alarmCode: 0)),
      SleepSegment(
          startTime: SegmentDateTime(hr: 12),
          endTime: SegmentDateTime(hr: 12, min: 30),
          alarmInfo: AlarmInfoModel.createDefaultUsingTime(
              SegmentDateTime(hr: 12, min: 30)),
          isSelected: true)
    ];
    final tSchedule = SleepSchedule(segments: tSegments);
    final ringTime = SegmentDateTime(hr: 12, min: 30);
    final params = Params(
        alarmInfo:
            AlarmInfo(soundOn: true, ringTime: ringTime, vibrationOn: false),
        schedule: tSchedule);
    when(mockScheduleEditorRepository.putCurrentSchedule(any))
        .thenAnswer((_) async => Right(null));
    // act
    usecase(params);

    // assert
    await untilCalled(mockScheduleEditorRepository.putCurrentSchedule(any));
    verify(mockPlatformRepository.setAlarm((AlarmInfo(
        ringTime: ringTime, soundOn: true, vibrationOn: false, alarmCode: 1))));
  });

  test(
      "If we are changing the time of a current alarm, delete it and re-create using same code.",
      () async {
    // arrange
    final tSegments = [
      SleepSegment(
          startTime: SegmentDateTime(hr: 22),
          endTime: SegmentDateTime(hr: 4),
          alarmInfo: AlarmInfo(
              ringTime: SegmentDateTime(hr: 4),
              soundOn: true,
              vibrationOn: true,
              alarmCode: 0)),
      SleepSegment(
        startTime: SegmentDateTime(hr: 12),
        endTime: SegmentDateTime(hr: 12, min: 30),
        alarmInfo: AlarmInfo(
            ringTime: SegmentDateTime(hr: 12, min: 30),
            soundOn: true,
            vibrationOn: true,
            alarmCode: 1),
        isSelected: true,
      )
    ];
    // We will be altering time of second alarm
    final tSchedule = SleepSchedule(segments: tSegments);
    final ringTime = SegmentDateTime(hr: 12, min: 30);
    final params = Params(
        alarmInfo: AlarmInfo(
            soundOn: true,
            ringTime: ringTime,
            vibrationOn: false,
            alarmCode: 1),
        schedule: tSchedule);
    when(mockScheduleEditorRepository.putCurrentSchedule(any))
        .thenAnswer((_) async => Right(null));
    // act
    usecase(params);

    // assert
    await untilCalled(mockScheduleEditorRepository.putCurrentSchedule(any));
    verify(mockPlatformRepository.deleteAlarm(AlarmInfo(
        ringTime: ringTime, soundOn: true, vibrationOn: false, alarmCode: 1)));
    verify(mockPlatformRepository.setAlarm(AlarmInfo(
        ringTime: ringTime, soundOn: true, vibrationOn: false, alarmCode: 1)));
  });

  test('If we are deleting an alarm, make sure setAlarm is not called',
      () async {
    // arrange
    final tSegments = [
      SleepSegment(
          startTime: SegmentDateTime(hr: 22),
          endTime: SegmentDateTime(hr: 4),
          alarmInfo: AlarmInfo(
              ringTime: SegmentDateTime(hr: 4),
              soundOn: true,
              vibrationOn: true,
              alarmCode: 0)),
      SleepSegment(
        startTime: SegmentDateTime(hr: 12),
        endTime: SegmentDateTime(hr: 12, min: 30),
        alarmInfo: AlarmInfo(
            ringTime: SegmentDateTime(hr: 12, min: 30),
            soundOn: true,
            vibrationOn: true,
            alarmCode: 1),
        isSelected: true,
      )
    ];
    // We will be deleting  second alarm
    final tSchedule = SleepSchedule(segments: tSegments);
    final ringTime = SegmentDateTime(hr: 12, min: 30);
    final params = Params(
        alarmInfo: AlarmInfo(
            soundOn: false,
            ringTime: ringTime,
            vibrationOn: false,
            alarmCode: 1),
        schedule: tSchedule);
    when(mockScheduleEditorRepository.putCurrentSchedule(any))
        .thenAnswer((_) async => Right(null));
    // act
    usecase(params);

    // assert
    await untilCalled(mockScheduleEditorRepository.putCurrentSchedule(any));
    verify(mockPlatformRepository.deleteAlarm(AlarmInfo(
        ringTime: ringTime, soundOn: false, vibrationOn: false, alarmCode: 1)));
    verifyNoMoreInteractions(mockPlatformRepository);
  });
}
