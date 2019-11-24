import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:polysleep/core/usecases/usecase.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/get_current_or_default_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/get_current_time.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/get_default_schedule.dart';
import 'package:polysleep/features/schedule_manager/presentation/view_models/home_view_model.dart';

class MockGetCurrentOrDefaultSchedule extends Mock
    implements GetCurrentOrDefaultSchedule {}

class MockGetDefaultSchedule extends Mock implements GetDefaultSchedule {}

class MockGetCurrentTime extends Mock implements GetCurrentTime {}

void main() {
  HomeViewModel model;
  MockGetCurrentOrDefaultSchedule mockGetCurrentOrDefaultSchedule;
  MockGetCurrentTime mockGetCurrentTime;
  final tSegments = [
    SleepSegment(
        startTime: SegmentDateTime(hr: 22), endTime: SegmentDateTime(hr: 6))
  ];
  final tSleepSchedule = SleepSchedule(name: "Monophasic", segments: tSegments);

  setUp(() {
    mockGetCurrentOrDefaultSchedule = MockGetCurrentOrDefaultSchedule();
    mockGetCurrentTime = MockGetCurrentTime();
    when(mockGetCurrentOrDefaultSchedule(any))
        .thenAnswer((_) async => Right(tSleepSchedule));
    when(mockGetCurrentTime()).thenReturn(SegmentDateTime(hr: 11));

    model = HomeViewModel(
        getCurrentOrDefaultSchedule: mockGetCurrentOrDefaultSchedule,
        getCurrentTime: mockGetCurrentTime);
  });

  test('loadSchedule() should call getCurrentOrDefaultSchedule', () async {
    // arrange

    // act
    model.onLoadSchedule();
    await untilCalled(mockGetCurrentOrDefaultSchedule(any));

    // assert
    verify(mockGetCurrentOrDefaultSchedule(NoParams()));
  });

  final tSleepScheduleEmpty =
      SleepSchedule(segments: [], difficulty: 'Nil', name: 'Test');
  test('should not show nav arrows if we have 0 segments', () async {
    // arrange
    when(mockGetCurrentOrDefaultSchedule(any))
        .thenAnswer((_) async => Right(tSleepScheduleEmpty));

    // act
    model.onLoadSchedule();
    await untilCalled(mockGetCurrentOrDefaultSchedule(any));
    // assert
    expect(model.shouldShowNapNavigationArrows, false);
  });

  test('should not show nav arrows if we have 1 segment', () async {
    // assert
    expect(model.shouldShowNapNavigationArrows, false);
  });

  final tSegmentsB = [
    SleepSegment(
        startTime: SegmentDateTime(hr: 23), endTime: SegmentDateTime(hr: 5)),
    SleepSegment(
        startTime: SegmentDateTime(hr: 12),
        endTime: SegmentDateTime(hr: 12, min: 30))
  ];
  final tSleepScheduleMultiple = SleepSchedule(segments: tSegmentsB);
  test('should show arrows if we have at least 2 segments', () async {
    // arrange
    when(mockGetCurrentOrDefaultSchedule(any))
        .thenAnswer((_) async => Right(tSleepScheduleMultiple));

    // act
    model.onLoadSchedule();
    await untilCalled(mockGetCurrentOrDefaultSchedule(any));

    // assert
    expect(model.shouldShowNapNavigationArrows, true);
  });

  test('selected segment should default to first segment after current time',
      () async {
    // arrange
    when(mockGetCurrentOrDefaultSchedule(any))
        .thenAnswer((_) async => Right(tSleepScheduleMultiple));

    // act
    model.onLoadSchedule();
    await untilCalled(mockGetCurrentOrDefaultSchedule(any));

    // assert
    expect(model.currentSchedule.segments[1].isSelected, true);
  });

  test(
      'selected segment should default to first segment after current time (test seg that goes over midnight)',
      () async {
    // arrange
    when(mockGetCurrentOrDefaultSchedule(any))
        .thenAnswer((_) async => Right(tSleepScheduleMultiple));
    when(mockGetCurrentTime()).thenReturn(SegmentDateTime(hr: 13));

    // act
    model.onLoadSchedule();
    await untilCalled(mockGetCurrentOrDefaultSchedule(any));

    // assert
    expect(model.currentSchedule.segments[0].isSelected, true);
  });

  test(
      'selected segment should move forward one index when right button tapped',
      () async {
    // arrange
    when(mockGetCurrentOrDefaultSchedule(any))
        .thenAnswer((_) async => Right(tSleepScheduleMultiple));
    model.onLoadSchedule();
    await untilCalled(mockGetCurrentOrDefaultSchedule(any));
    expect(model.currentSchedule.segments[1].isSelected, true);

    // act
    model.onRightNapArrowTapped();

    // assert
    expect(model.currentSchedule.segments[0].isSelected, true);
    expect(model.currentSchedule.segments[1].isSelected, false);
  });

  test('selected segment should move back one index when left button tapped',
      () async {
    // arrange
    when(mockGetCurrentOrDefaultSchedule(any))
        .thenAnswer((_) async => Right(tSleepScheduleMultiple));
    model.onLoadSchedule();
    await untilCalled(mockGetCurrentOrDefaultSchedule(any));
    expect(model.currentSchedule.segments[1].isSelected, true);

    // act
    model.onLeftNapArrowTapped();

    // assert
    expect(model.currentSchedule.segments[0].isSelected, true);
    expect(model.currentSchedule.segments[1].isSelected, false);
  });
}
