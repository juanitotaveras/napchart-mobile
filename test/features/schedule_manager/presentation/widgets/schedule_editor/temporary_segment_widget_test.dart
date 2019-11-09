import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_bloc.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_event.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_state.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/view_model_provider.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/scheduler_editor/loaded_segment_widget.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/scheduler_editor/temporary_segment_widget.dart';

class MockBloc extends Mock implements ScheduleEditorBloc {}

void main() {
  group('temporary segments widget', () {
    ScheduleEditorBloc bloc;
    setUp(() {
      bloc = MockBloc();
      final state = SegmentsLoaded(
          loadedSegments: <SleepSegment>[],
          selectedSegment: SleepSegment(
              startTime: SegmentDateTime(hr: 22),
              endTime: SegmentDateTime(hr: 6)));
      when(bloc.currentState).thenAnswer((_) => state);
    });
    /*testWidgets('Widget dispatches event when tapped',
        (WidgetTester tester) async {
      // arrange
      final index = 0;
      final widgetUnderTest =
          TemporarySegmentWidget(marginRight: 5, hourSpacing: 60);
      final w = BlocProvider(
          builder: (context) => bloc,
          child: MaterialApp(home: Scaffold(body: widgetUnderTest)));
      await tester.pumpWidget(w);

      // act
      await tester.tap(find.byWidget(widgetUnderTest));

      // assert
      verify(bloc.dispatch(LoadedSegmentTapped(index)));
    });*/

    testWidgets('Should only have one block if segments is in one day',
        (WidgetTester tester) async {
      final state = SegmentsLoaded(
          loadedSegments: <SleepSegment>[],
          selectedSegment: SleepSegment(
              startTime: SegmentDateTime(hr: 22),
              endTime: SegmentDateTime(hr: 23)));
      when(bloc.currentState).thenAnswer((_) => state);
      final widgetUnderTest =
          TemporarySegmentWidget(marginRight: 5, hourSpacing: 60);
      final w = ViewModelProvider(
          builder: (context) => bloc,
          child: MaterialApp(home: Scaffold(body: widgetUnderTest)));
      await tester.pumpWidget(w);

      // act

      // assert
      final widgets = find.byKey(Key('tempPiece'));
      expect(widgets, findsOneWidget);
    });

    testWidgets('Should have two blocks if segment spans two days',
        (WidgetTester tester) async {
      final widgetUnderTest =
          TemporarySegmentWidget(marginRight: 5, hourSpacing: 60);
      final w = ViewModelProvider(
          builder: (context) => bloc,
          child: MaterialApp(home: Scaffold(body: widgetUnderTest)));
      await tester.pumpWidget(w);

      // act
      final widgets = find.byKey(Key('tempPiece'));

      expect(widgets, findsNWidgets(2));
    });
  });
}
