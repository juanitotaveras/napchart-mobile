import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:polysleep/core/error/exceptions.dart';
import 'package:polysleep/features/schedule_manager/data/datasources/assets_data_source.dart';
import 'package:matcher/matcher.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_schedule_model.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_segment_model.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';

import '../../../../fixtures/fixtures_reader.dart';

class MockFileReader extends Mock implements File {}

void main() {
  AssetsDataSource dataSource;
  MockFileReader mockFileReader;
  setUp(() {
    dataSource = AssetsDataSourceImpl();
    mockFileReader = MockFileReader();
  });

  group('getDefaultSchedule', () {
    final tSegments = [
      SleepSegmentModel(
          startTime: SegmentDateTime(hr: 22), endTime: SegmentDateTime(hr: 6))
    ];
    final tSleepScheduleModel =
        SleepScheduleModel(name: "Monophasic", segments: tSegments);

    /*
        TODO: Can't really mock file not existing, so skipping this for now.
    test('should throw AssetsException if asset not present', () async {
      // arrange
      when(mockFileReader(any)).thenAnswer((_) async ))
      // act
      final call = dataSource.getDefaultSchedule;
      // assert
      expect(() => call(), throwsA(TypeMatcher<AssetsException>()));
    }); */

    test('should return SleepScheduleModel from assets when asset is present',
        () async {
      // arrange
      // act
      final result = await dataSource.getDefaultSchedule();

      // assert
      expect(result, equals(tSleepScheduleModel));
    });
  });
}
