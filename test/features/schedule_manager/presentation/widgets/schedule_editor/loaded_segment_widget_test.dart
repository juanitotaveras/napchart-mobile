import 'package:flutter_test/flutter_test.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/view_models/schedule_editor_view_model.dart';
import 'package:polysleep/features/schedule_manager/presentation/view_models/view_model_provider.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/scheduler_editor/loaded_segment_widget.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';

class MockBloc extends Mock implements ScheduleEditorViewModel {}

void main() {
  group('loaded segments widget', () {
    ScheduleEditorViewModel bloc;
    setUp(() {
      bloc = MockBloc();
    });
    testWidgets('Widget dispatches event when tapped',
        (WidgetTester tester) async {
      // arrange
      final index = 0;
      final widgetUnderTest = LoadedSegmentWidget(
          key: Key('k'),
          marginRight: 5,
          hourSpacing: 60,
          segment: SleepSegment(
              startTime: SegmentDateTime(hr: 1, min: 0),
              endTime: SegmentDateTime(hr: 2, min: 0)),
          index: index);
      final w = ViewModelProvider(
          bloc: bloc,
          child: MaterialApp(home: Scaffold(body: widgetUnderTest)));
      await tester.pumpWidget(w);

      // act
      await tester.tap(find.byWidget(widgetUnderTest));

      // assert
      verify(bloc.onLoadedSegmentTapped(index));
    });

    testWidgets('Should only have one block if segments is in one day',
        (WidgetTester tester) async {
      final index = 0;

      final widgetUnderTest = LoadedSegmentWidget(
          marginRight: 5,
          hourSpacing: 60,
          segment: SleepSegment(
              startTime: SegmentDateTime(hr: 1, min: 0),
              endTime: SegmentDateTime(hr: 2, min: 0)),
          index: index);
      final w = ViewModelProvider(
          bloc: bloc,
          child: MaterialApp(home: Scaffold(body: widgetUnderTest)));
      await tester.pumpWidget(w);

      // act

      // assert
      final widgets = find.byKey(Key('piece'));
      expect(widgets, findsOneWidget);
    });

    testWidgets('Should have two blocks if segment spans two days',
        (WidgetTester tester) async {
      final startTime = SegmentDateTime(hr: 22);
      final endTime = SegmentDateTime(hr: 6);
      assert(startTime.isAfter(endTime));

      final widgetUnderTest = LoadedSegmentWidget(
          marginRight: 5,
          hourSpacing: 60,
          segment: SleepSegment(startTime: startTime, endTime: endTime),
          index: 0);
      final w = ViewModelProvider(
          bloc: bloc,
          child: MaterialApp(home: Scaffold(body: widgetUnderTest)));
      await tester.pumpWidget(w);

      // act
      final widgets = find.byKey(Key('piece'));

      expect(widgets, findsNWidgets(2));
    });
  });
}
