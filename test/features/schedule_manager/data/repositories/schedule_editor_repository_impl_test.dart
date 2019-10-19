import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:polysleep/features/schedule_manager/data/datasources/preferences_data_source.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_schedule_model.dart';
import 'package:polysleep/features/schedule_manager/data/repositories/schedule_editor_repository_impl.dart';
import 'package:polysleep/features/schedule_manager/domain/repositories/schedule_editor_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockPreferencesDataSource extends Mock implements PreferencesDataSource {}

void main() {
  ScheduleEditorRepository repository;
  PreferencesDataSource dataSource;
  setUp(() {
    dataSource = MockPreferencesDataSource();
    repository =
        ScheduleEditorRepositoryImpl(preferencesDataSource: dataSource);
  });

  group('get current schedule', () {
    final tSleepScheduleModel = SleepScheduleModel(segments: []);
    test('should call prefs data source to get current schedule', () async {
      // arrange
      when(dataSource.getCurrentSchedule())
          .thenAnswer((_) async => tSleepScheduleModel);

      // act
      await repository.getCurrentSchedule();

      // assert
      verify(dataSource.getCurrentSchedule());
    });
  });
}
