import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:polysleep/core/error/exceptions.dart';
import 'package:polysleep/features/schedule_manager/data/datasources/assets_data_source.dart';
import 'package:matcher/matcher.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_schedule_model.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_segment_model.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:flutter/services.dart' show AssetBundle;

import '../../../../fixtures/fixtures_reader.dart';

class MockAssetBundle extends Mock implements AssetBundle {}

void main() {
  AssetsDataSource dataSource;
  MockAssetBundle mockAssetBundle;
  setUp(() {
    dataSource = AssetsDataSourceImpl(rootBundle: mockAssetBundle);
    mockAssetBundle = MockAssetBundle();
  });

  group('getDefaultSchedule', () {
    setUp(() {
      dataSource = AssetsDataSourceImpl(rootBundle: mockAssetBundle);
      mockAssetBundle = MockAssetBundle();
    });
    final tSegments = [
      SleepSegmentModel(
          startTime: SegmentDateTime(hr: 22), endTime: SegmentDateTime(hr: 6))
    ];
    final tSleepScheduleModel =
        SleepScheduleModel(name: "Monophasic", segments: tSegments);
/* TODO: Error: getter 'length' was called on null
    test('should throw AssetsException if asset not present', () async {
      // arrange
      when(mockAssetBundle.loadString(any)).thenThrow(Exception());
      // act
      final call = dataSource.getDefaultSchedule;
      // assert
      expect(() => call(), throwsA(TypeMatcher<AssetsException>()));
    }); */
    // TODO: Fix this exception:
    //noSuchMethodError: The getter 'length' was called on null.
/*
    test('should return SleepScheduleModel from assets when asset is present',
        () async {
      // arrange
      final String scheduleFromFixture = fixture('test_schedule.json');
      print('cake $scheduleFromFixture');
      when(mockAssetBundle.loadString(any))
          .thenAnswer((_) async => scheduleFromFixture);
      // act
      final result = await dataSource.getDefaultSchedule();

      // assert
      expect(result, equals(tSleepScheduleModel));
    });*/
  });
}
