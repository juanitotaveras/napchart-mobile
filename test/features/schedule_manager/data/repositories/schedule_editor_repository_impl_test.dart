import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:polysleep/features/schedule_manager/data/datasources/preferences_data_source.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_schedule_model.dart';
import 'package:polysleep/features/schedule_manager/data/repositories/schedule_editor_repository_impl.dart';
import 'package:polysleep/features/schedule_manager/domain/repositories/schedule_editor_repository.dart';

class MockPreferencesDataSource extends Mock implements PreferencesDataSource {}

void main() {
  ScheduleEditorRepository repository;
  MockPreferencesDataSource mockPreferencesDataSource;

  setUp(() {
    mockPreferencesDataSource = MockPreferencesDataSource();
    repository = ScheduleEditorRepositoryImpl(
        preferencesDataSource: mockPreferencesDataSource);
  });

  group('get current schedule', () {
    final tSleepScheduleModel = SleepScheduleModel(segments: []);
    test('should call shared prefs to get current schedule', () async {
      // arrange

      // act
      mockPreferencesDataSource.getCurrentSchedule();

      final expectedJsonString = json.encode(tSleepScheduleModel.toJson());
      repository.getCurrentSchedule();

      verify(mockPreferencesDataSource.setString(
          CURRENT_SCHEDULE, expectedJsonString));
    });
  });
}
