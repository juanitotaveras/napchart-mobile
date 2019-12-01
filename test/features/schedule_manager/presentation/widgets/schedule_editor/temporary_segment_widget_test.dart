import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/view_models/schedule_editor_view_model.dart';
import 'package:polysleep/features/schedule_manager/presentation/view_models/view_model_provider.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/scheduler_editor/loaded_segment_widget.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/scheduler_editor/temporary_segment_widget.dart';
import 'package:rxdart/rxdart.dart';

class MockBloc extends Mock implements ScheduleEditorViewModel {}

void main() {
  group('temporary segments widget', () {
    ScheduleEditorViewModel bloc;
    final tSegments = [
      SleepSegment(
          startTime: SegmentDateTime(hr: 22), endTime: SegmentDateTime(hr: 6))
    ];
    final tSleepSchedule =
        SleepSchedule(name: "Monophasic", segments: tSegments);
    setUp(() {
      bloc = MockBloc();

      // when().thenAnswer((_) => state);
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
      // when(bloc.getCurrentOrDefaultSchedule(any))
      //     .thenAnswer((_) async => Right(tSleepSchedule));
      // can we mock stream?
      final mockStream = BehaviorSubject<SleepSegment>.seeded(tSegments[0]);
      // mockStream.add(tSegments[0]);
      when(bloc.selectedSegmentStream).thenAnswer((_) => mockStream);
      when(bloc.selectedSegment).thenReturn(SleepSegment(
          startTime: SegmentDateTime(hr: 1), endTime: SegmentDateTime(hr: 3)));
      final widgetUnderTest =
          TemporarySegmentWidget(marginRight: 5, hourSpacing: 60);
      final w = ViewModelProvider(
          bloc: bloc,
          child: MaterialApp(home: Scaffold(body: widgetUnderTest)));
      // bloc.onLoadSchedule();
      await tester.pumpWidget(w);
      // act

      // assert
      final widgets = find.byKey(Key('tempPiece'));
      expect(widgets, findsOneWidget);
      // TODO: Figure out why snapshot.data is null...

      mockStream.close();
    });

    testWidgets('Should have two blocks if segment spans two days',
        (WidgetTester tester) async {
      final widgetUnderTest =
          TemporarySegmentWidget(marginRight: 5, hourSpacing: 60);
      when(bloc.selectedSegment).thenReturn(tSegments[0]);
      final w = ViewModelProvider(
          bloc: bloc,
          child: MaterialApp(home: Scaffold(body: widgetUnderTest)));
      await tester.pumpWidget(w);

      // act
      final widgets = find.byKey(Key('tempPiece'));

      expect(widgets, findsNWidgets(2));
    });
  });
}
