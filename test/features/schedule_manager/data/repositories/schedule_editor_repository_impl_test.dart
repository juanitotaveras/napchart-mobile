import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:polysleep/core/error/exceptions.dart';
import 'package:polysleep/core/error/failure.dart';
import 'package:polysleep/features/schedule_manager/data/datasources/assets_data_source.dart';
import 'package:polysleep/features/schedule_manager/data/datasources/preferences_data_source.dart';
import 'package:polysleep/features/schedule_manager/data/models/alarm_info_model.dart';
import 'package:polysleep/features/schedule_manager/data/models/notification_info_model.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_schedule_model.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_segment_model.dart';
import 'package:polysleep/features/schedule_manager/data/repositories/schedule_editor_repository_impl.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/repositories/schedule_editor_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockPreferencesDataSource extends Mock implements PreferencesDataSource {}

class MockAssetsDataSource extends Mock implements AssetsDataSource {}

void main() {
  ScheduleEditorRepository repository;
  PreferencesDataSource preferencesDataSource;
  AssetsDataSource assetsDataSource;
  setUp(() {
    preferencesDataSource = MockPreferencesDataSource();
    assetsDataSource = MockAssetsDataSource();
    repository = ScheduleEditorRepositoryImpl(
        preferencesDataSource: preferencesDataSource,
        assetsDataSource: assetsDataSource);
  });

  group('get current schedule', () {
    final tSegments = [
      SleepSegmentModel(
          startTime: SegmentDateTime(hr: 22), endTime: SegmentDateTime(hr: 6))
    ];
    final tSleepScheduleModel =
        SleepScheduleModel(name: "Monophasic", segments: tSegments);
    test('should call prefs data source to get current schedule', () async {
      // arrange
      when(preferencesDataSource.getCurrentSchedule())
          .thenAnswer((_) async => tSleepScheduleModel);

      // act
      final result = await repository.getCurrentSchedule();

      // assert
      verify(preferencesDataSource.getCurrentSchedule());
      expect(result, Right(tSleepScheduleModel));
    });

    test('should return failure when call is not successful', () async {
      // arrange
      when(preferencesDataSource.getCurrentSchedule())
          .thenThrow(PreferencesException());

      // act
      final result = await repository.getCurrentSchedule();

      // assert
      verify(preferencesDataSource.getCurrentSchedule());
      expect(result, equals(Left(PreferencesFailure())));
    });
  });
  group('get default schedule', () {
    final tSegments = [
      SleepSegmentModel(
          startTime: SegmentDateTime(hr: 22), endTime: SegmentDateTime(hr: 6))
    ];
    final tSleepScheduleModel =
        SleepScheduleModel(name: "Monophasic", segments: tSegments);

    test('should parse monophasic asset to get default schedule', () async {
      // arrange
      when(assetsDataSource.getDefaultSchedule())
          .thenAnswer((_) async => tSleepScheduleModel);

      // act
      final result = await repository.getDefaultSchedule();

      verify(assetsDataSource.getDefaultSchedule());
      expect(result, Right(tSleepScheduleModel));
    });

    test('should return failure when call not successful', () async {
      when(assetsDataSource.getDefaultSchedule()).thenThrow(AssetsException());

      // act
      final result = await repository.getDefaultSchedule();

      verify(assetsDataSource.getDefaultSchedule());
      expect(result, equals(Left(AssetsFailure())));
    });
  });

  group('put current schedule', () {
    final tSegments = [
      SleepSegmentModel(
          startTime: SegmentDateTime(hr: 22),
          endTime: SegmentDateTime(hr: 6),
          alarmInfo: AlarmInfoModel(
              ringTime: SegmentDateTime(hr: 6),
              alarmCode: 0,
              vibrationOn: true,
              soundOn: true),
          notificationInfo: NotificationInfoModel(
              isOn: true, notifyTime: SegmentDateTime(hr: 22)))
    ];
    final tSleepScheduleModel =
        SleepScheduleModel(name: "Monophasic", segments: tSegments);
    test('should return failure when put not successful', () async {
      when(preferencesDataSource.putCurrentSchedule(any))
          .thenThrow(PreferencesException());

      // act
      final result = await repository.putCurrentSchedule(tSleepScheduleModel);

      verify(preferencesDataSource.putCurrentSchedule(any));
      expect(result, equals(Left(PreferencesFailure())));
    });

    test('should store current schedule and return nothing if successful',
        () async {
      when(preferencesDataSource.putCurrentSchedule(any))
          .thenAnswer((_) async => tSleepScheduleModel);

      // act
      final result = await repository.putCurrentSchedule(tSleepScheduleModel);

      verify(preferencesDataSource.putCurrentSchedule(any));
      expect(result, equals(Right(null)));
    });
  });
}
