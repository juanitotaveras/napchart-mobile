import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_bloc.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_event.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_state.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/scheduler_editor/loaded_segment_widget.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';

class MockBloc extends Mock implements ScheduleEditorBloc {}

void main() {
  group('loaded segments widget', () {
    ScheduleEditorBloc bloc;
    setUp(() {
      bloc = MockBloc();
    });
    testWidgets('Widget dispatches event when tapped',
        (WidgetTester tester) async {
      // arrange
      final index = 0;
      final widgetUnderTest = LoadedSegmentWidget(
          marginRight: 5,
          hourSpacing: 60,
          segment: SleepSegment(
              startTime: SegmentDateTime(hr: 1, min: 0),
              endTime: SegmentDateTime(hr: 2, min: 0)),
          index: index);
      final w = BlocProvider(
          builder: (context) => bloc,
          child: MaterialApp(home: Scaffold(body: widgetUnderTest)));
      await tester.pumpWidget(w);

      // act
      await tester.tap(find.byWidget(widgetUnderTest));

      // assert
      verify(bloc.dispatch(LoadedSegmentTapped(index)));
    });
  });
}
