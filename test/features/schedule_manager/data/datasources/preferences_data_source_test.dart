import 'package:mockito/mockito.dart';
import 'package:polysleep/core/error/exceptions.dart';
import 'package:polysleep/features/schedule_manager/data/datasources/preferences_data_source.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_schedule_model.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_segment_model.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixtures_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences mockSharedPreferences;
  PreferencesDataSource dataSource;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource =
        PreferencesDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getCurrentSchedule', () {
    final tSegments = [
      SleepSegmentModel(
          startTime: SegmentDateTime(hr: 22), endTime: SegmentDateTime(hr: 6))
    ];
    final tSleepScheduleModel =
        SleepScheduleModel(name: "Monophasic", segments: tSegments);
    test(
      'should throw a PreferencesException when there is no value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getCurrentSchedule;
        // assert
        expect(() => call(), throwsA(TypeMatcher<PreferencesException>()));
      },
    );

    test(
        'should return SleepScheduleModel from SharedPreferences when value is present',
        () async {
      // arrange
      // final String scheduleFromFixture = fixture('test_schedule.json');
      // when(mockSharedPreferences.getString(any))
      //     .thenReturn(scheduleFromFixture);

      // act
      // final result = await dataSource.getCurrentSchedule();

      // assert
      // verify(mockSharedPreferences.getString(CURRENT_SCHEDULE));
      // expect(result, equals(tSleepScheduleModel));
    });
  });
}
