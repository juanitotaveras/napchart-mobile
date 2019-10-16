import 'package:flutter_test/flutter_test.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/bloc.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_bloc.dart';

class MockScheduleEditorBloc extends ScheduleEditorBloc {}

void main() {
  ScheduleEditorBloc bloc;

  setUp(() {
    bloc = MockScheduleEditorBloc();
  });

  test('initial state should be initState', () {
    // assert
    expect(bloc.initialState, equals(Init()));
  });

  test('should get current schedule from repository after init', () {
    // arrange
    //

    // act

    // assert
  });
  test(
      'should move current segment into selectedSegment when LoadedSegmentTapped',
      () async {
    // arrange

    // act

    // assert
  });
}
