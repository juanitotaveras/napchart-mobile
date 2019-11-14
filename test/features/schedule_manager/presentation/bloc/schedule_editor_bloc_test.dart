import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:polysleep/core/error/failure.dart';
import 'package:polysleep/core/usecases/usecase.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/get_current_or_default_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/get_current_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/get_default_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/save_current_schedule.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/bloc.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_view_model.dart';

class MockGetCurrentOrDefaultSchedule extends Mock
    implements GetCurrentOrDefaultSchedule {}

class MockGetDefaultSchedule extends Mock implements GetDefaultSchedule {}

class MockSaveCurrentSchedule extends Mock implements SaveCurrentSchedule {}

void main() {
  ScheduleEditorViewModel bloc;
  MockGetCurrentOrDefaultSchedule mockGetCurrentOrDefaultSchedule;
  MockSaveCurrentSchedule mockSaveCurrentSchedule;

  setUp(() {
    mockGetCurrentOrDefaultSchedule = MockGetCurrentOrDefaultSchedule();
    mockSaveCurrentSchedule = MockSaveCurrentSchedule();
    bloc = ScheduleEditorViewModel(
        getCurrentOrDefaultSchedule: mockGetCurrentOrDefaultSchedule,
        saveCurrentSchedule: mockSaveCurrentSchedule);
  });

  final tSegments = [
    SleepSegment(
        startTime: SegmentDateTime(hr: 22), endTime: SegmentDateTime(hr: 6))
  ];
  final tSleepSchedule = SleepSchedule(name: "Monophasic", segments: tSegments);

  // test('initial state should be initState', () {
  //   // assert
  //   expect(bloc.initialState, equals(Init()));
  // });

  test(
      'should move current segment into selectedSegment when LoadedSegmentTapped',
      () async {
    // arrange

    // act

    // assert
  });

  test('should delete segment when deleteSelectedSegmentPressed', () async {
    // arrange
    when(mockGetCurrentOrDefaultSchedule(any))
        .thenAnswer((_) async => Right(tSleepSchedule));
    await bloc.onLoadSchedule();
    await bloc.onLoadedSegmentTapped(0);

    // act
    await bloc.onDeleteSelectedSegmentPressed();

    // assert
    List<SleepSegment> segments = bloc.loadedSegments;
    expect(segments.length, tSleepSchedule.segments.length - 1);
  });

  test('Should call getCurrentSchedule when LoadSegments received', () async {
    // arrange
    when(mockGetCurrentOrDefaultSchedule(any))
        .thenAnswer((_) async => Right(tSleepSchedule));
    // act
    bloc.onLoadSchedule();
    await untilCalled(mockGetCurrentOrDefaultSchedule(any));

    // assert
    verify(mockGetCurrentOrDefaultSchedule(NoParams()));
  });

  test(
      'Should yield segments loaded with current segments current schedule case successful',
      () async {
    // arrange
    when(mockGetCurrentOrDefaultSchedule(any))
        .thenAnswer((_) async => Right(tSleepSchedule));

    // assert later
    final expected = [
      Init(),
      SegmentsLoaded(loadedSegments: tSleepSchedule.segments)
    ];
    // expectLater(bloc.state, emitsInOrder(expected));

    // act
    bloc.onLoadSchedule();
  });

  test('Should call GetDefaultSchedule if we fail to get currentSchedule',
      () async {
    // arrange
    when(mockGetCurrentOrDefaultSchedule(any))
        .thenAnswer((_) async => Left(PreferencesFailure()));

    // act
    bloc.onLoadSchedule();
    await untilCalled(mockGetCurrentOrDefaultSchedule(any));

    // assert
    verify(mockGetCurrentOrDefaultSchedule(NoParams()));
    verify(mockGetCurrentOrDefaultSchedule(NoParams()));
  });

  test(
      'Should yield segments laoded with default if current schedule fails and default succeeds',
      () async {
    // arrange
    when(mockGetCurrentOrDefaultSchedule(any))
        .thenAnswer((_) async => Left(PreferencesFailure()));
    when(mockGetCurrentOrDefaultSchedule(any))
        .thenAnswer((_) async => Right(tSleepSchedule));

    // assert later
    final expected = [
      Init(),
      SegmentsLoaded(loadedSegments: tSleepSchedule.segments)
    ];
    // expectLater(bloc.state, emitsInOrder(expected));

    // act
    bloc.onLoadSchedule();
  });

  test(
      'Should call saveCurrentSchedule use case when button button press received',
      () async {
    // arrange
    // arrange
    when(mockGetCurrentOrDefaultSchedule(any))
        .thenAnswer((_) async => Right(tSleepSchedule));
    when(mockSaveCurrentSchedule(any))
        .thenAnswer((_) async => Right(tSleepSchedule));
    bloc.onLoadSchedule();

    await untilCalled(mockGetCurrentOrDefaultSchedule(any));
    // act
    bloc.onSaveChangesPressed();
    await untilCalled(mockSaveCurrentSchedule(any));
    // assert
    verify(mockGetCurrentOrDefaultSchedule(any));
    verify(mockSaveCurrentSchedule(any));
  });

  test('Should show error if saveCurrentSchedule fails', () async {});

  test('Should mark segment we are editing when LoadedSegmentTapepd', () async {
    // arrange
    when(mockGetCurrentOrDefaultSchedule(any))
        .thenAnswer((_) async => Right(tSleepSchedule));

    // assert later
    final tModifiedSchedule = SleepSchedule(
        segments: tSleepSchedule.segments
            .map((seg) => SleepSegment(
                startTime: seg.startTime,
                endTime: seg.endTime,
                name: seg.name,
                isSelected: true))
            .toList());
    final seg = tSleepSchedule.segments[0];
    final tModifiedSegment = SleepSegment(
        startTime: seg.startTime,
        endTime: seg.endTime,
        name: seg.name,
        isSelected: true);
    final expected = [
      Init(),
      SegmentsLoaded(loadedSegments: tSleepSchedule.segments),
      SegmentsLoaded(
          loadedSegments: tModifiedSchedule.segments,
          selectedSegment: tModifiedSegment)
    ];
    // expectLater(bloc.state, emitsInOrder(expected));

    // act
    bloc.onLoadSchedule();
    await untilCalled(mockGetCurrentOrDefaultSchedule(any));
    bloc.onLoadedSegmentTapped(0);
  });

  test(
      'Should replace editing segment with temporary segment when save pressed',
      () async {
    // arrange
    when(mockGetCurrentOrDefaultSchedule(any))
        .thenAnswer((_) async => Right(tSleepSchedule));

    // assert later
    final tModifiedSchedule = SleepSchedule(
        segments: tSleepSchedule.segments
            .map((seg) => SleepSegment(
                startTime: seg.startTime,
                endTime: seg.endTime,
                name: seg.name,
                isSelected: true))
            .toList());
    final seg = tSleepSchedule.segments[0];
    final tModifiedSegment = SleepSegment(
        startTime: seg.startTime,
        endTime: seg.endTime,
        name: seg.name,
        isSelected: true);

    // TODO: Need to simulate start time being changed
    final expected = [
      Init(),
      SegmentsLoaded(loadedSegments: tSleepSchedule.segments),
      SegmentsLoaded(
          loadedSegments: tModifiedSchedule.segments,
          selectedSegment: tModifiedSegment),
      SegmentsLoaded(
          loadedSegments: tSleepSchedule.segments, selectedSegment: null)
    ];
    // expectLater(bloc.state, emitsInOrder(expected));

    // act
    bloc.onLoadSchedule();
    await untilCalled(mockGetCurrentOrDefaultSchedule(any));
    bloc.onLoadedSegmentTapped(0);
  });
}
