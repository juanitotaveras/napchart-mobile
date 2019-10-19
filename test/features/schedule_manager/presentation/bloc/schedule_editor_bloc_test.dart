import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:polysleep/core/error/failure.dart';
import 'package:polysleep/core/usecases/usecase.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/get_current_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/get_default_schedule.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/bloc.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_bloc.dart';

class MockGetCurrentSchedule extends Mock implements GetCurrentSchedule {}

class MockGetDefaultSchedule extends Mock implements GetDefaultSchedule {}

void main() {
  ScheduleEditorBloc bloc;
  MockGetCurrentSchedule mockGetCurrentSchedule;
  MockGetDefaultSchedule mockGetDefaultSchedule;

  setUp(() {
    mockGetDefaultSchedule = MockGetDefaultSchedule();
    mockGetCurrentSchedule = MockGetCurrentSchedule();
    bloc = ScheduleEditorBloc(
        getCurrentSchedule: mockGetCurrentSchedule,
        getDefaultSchedule: mockGetDefaultSchedule);
  });

  final tSegments = [
    SleepSegment(
        startTime: SegmentDateTime(hr: 22), endTime: SegmentDateTime(hr: 6))
  ];
  final tSleepSchedule = SleepSchedule(name: "Monophasic", segments: tSegments);

  test('initial state should be initState', () {
    // assert
    expect(bloc.initialState, equals(Init()));
  });

  test(
      'should move current segment into selectedSegment when LoadedSegmentTapped',
      () async {
    // arrange

    // act

    // assert
  });

  test('Should call getCurrentSchedule when LoadSegments received', () async {
    // arrange
    when(mockGetCurrentSchedule(any))
        .thenAnswer((_) async => Right(tSleepSchedule));
    // act
    bloc.dispatch(LoadSchedule());
    await untilCalled(mockGetCurrentSchedule(any));

    // assert
    verify(mockGetCurrentSchedule(NoParams()));
  });

  test(
      'Should yield segments loaded with current segments current schedule case successful',
      () async {
    // arrange
    when(mockGetCurrentSchedule(any))
        .thenAnswer((_) async => Right(tSleepSchedule));

    // assert later
    final expected = [
      Init(),
      SegmentsLoaded(loadedSegments: tSleepSchedule.segments)
    ];
    expectLater(bloc.state, emitsInOrder(expected));

    // act
    bloc.dispatch(LoadSchedule());
  });

  test('Should call GetDefaultSchedule if we fail to get currentSchedule',
      () async {
    // arrange
    when(mockGetCurrentSchedule(any))
        .thenAnswer((_) async => Left(PreferencesFailure()));

    // act
    bloc.dispatch(LoadSchedule());
    await untilCalled(mockGetDefaultSchedule(any));

    // assert
    verify(mockGetCurrentSchedule(NoParams()));
    verify(mockGetDefaultSchedule(NoParams()));
  });

  test(
      'Should yield segments laoded with default if current schedule fails and default succeeds',
      () async {
    // arrange
    when(mockGetCurrentSchedule(any))
        .thenAnswer((_) async => Left(PreferencesFailure()));
    when(mockGetDefaultSchedule(any))
        .thenAnswer((_) async => Right(tSleepSchedule));

    // assert later
    final expected = [
      Init(),
      SegmentsLoaded(loadedSegments: tSleepSchedule.segments)
    ];
    expectLater(bloc.state, emitsInOrder(expected));

    // act
    bloc.dispatch(LoadSchedule());
  });
}
