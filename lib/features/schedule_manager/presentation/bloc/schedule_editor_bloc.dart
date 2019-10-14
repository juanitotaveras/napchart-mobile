import 'dart:async';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import './bloc.dart';

class ScheduleEditorBloc
    extends Bloc<ScheduleEditorEvent, ScheduleEditorState> {
  @override
  ScheduleEditorState get initialState => InitialScheduleEditorState();

  @override
  Stream<ScheduleEditorState> mapEventToState(
    ScheduleEditorEvent event,
  ) async* {
    print('LE EVENT: $event');
    if (event is TemporarySleepSegmentCreated) {
      DateTime t = GridTapToTimeConverter.touchInputToTime(
          event.touchCoord, event.hourPixels, 30);
      DateTime endTime = t.add(Duration(minutes: 60));
      SleepSegment segment = SleepSegment(startTime: t, endTime: endTime);
      List<SleepSegment> loadedSegments = [];
      if (currentState is TemporarySegmentCreated) {
        loadedSegments =
            (currentState as TemporarySegmentCreated).loadedSegments;
      } else if (currentState is SelectedSegmentChanged) {
        loadedSegments =
            (currentState as SelectedSegmentChanged).loadedSegments;
      } else if (currentState is SegmentsLoaded) {
        loadedSegments = (currentState as SegmentsLoaded).loadedSegments;
      }
      yield TemporarySegmentCreated(
          selectedSegment: segment, loadedSegments: loadedSegments);
    } else if (event is TemporarySleepSegmentDragged) {
      final t = SegmentDragToTimeChangeConverter.dragInputToNewTime(
          event.details, event.calendarGrid, event.hourSpacing, 15);
      SleepSegment currentSegment = (currentState as dynamic).selectedSegment;
      if (t.compareTo(currentSegment.startTime) != 0) {
        final newSeg = SleepSegment(
            startTime: t,
            endTime:
                t.add(Duration(minutes: currentSegment.getDurationMinutes())));
        yield SelectedSegmentChanged(
            selectedSegment: newSeg,
            loadedSegments: (currentState as dynamic).loadedSegments);
      }
    } else if (event is TemporarySleepSegmentStartTimeDragged) {
      final t = SegmentDragToTimeChangeConverter.dragInputToNewTime(
          event.details, event.calendarGrid, event.hourSpacing, 5);
      SleepSegment currentSegment = (currentState as dynamic).selectedSegment;
      if (t.compareTo(currentSegment.startTime) != 0) {
        final newSeg =
            SleepSegment(startTime: t, endTime: currentSegment.endTime);
        yield SelectedSegmentChanged(
            selectedSegment: newSeg,
            loadedSegments: (currentState as dynamic).loadedSegments);
      }
    } else if (event is TemporarySleepSegmentEndTimeDragged) {
      final t = SegmentDragToTimeChangeConverter.dragInputToNewTime(
          event.details, event.calendarGrid, event.hourSpacing, 5);
      SleepSegment currentSegment = (currentState as dynamic).selectedSegment;
      if (t.compareTo(currentSegment.startTime) != 0) {
        final newSeg =
            SleepSegment(startTime: currentSegment.startTime, endTime: t);
        yield SelectedSegmentChanged(
            selectedSegment: newSeg,
            loadedSegments: (currentState as dynamic).loadedSegments);
      }
    } else if (event is SelectedSegmentCancelled) {
      yield SegmentsLoaded(
          loadedSegments: (currentState as dynamic).loadedSegments);
    } else if (event is SelectedSegmentSaved) {
      final SleepSegment savedSegment =
          (currentState as dynamic).selectedSegment;

      if (currentState is SelectedSegmentChanged) {
        yield SegmentsLoaded(loadedSegments: [
          savedSegment,
          ...(currentState as SelectedSegmentChanged).loadedSegments
        ]);
      } else if (currentState is TemporarySegmentCreated) {
        yield SegmentsLoaded(loadedSegments: [
          savedSegment,
          ...(currentState as TemporarySegmentCreated).loadedSegments
        ]);
      }
    }
  }
}

class GridTapToTimeConverter {
  static DateTime touchInputToTime(
      Offset tapPosition, double hourSpacing, int granularity) {
    var hr = tapPosition.dy ~/ hourSpacing;
    var min = ((tapPosition.dy % hourSpacing) ~/ granularity) * granularity;
    return SegmentDateTime(hr: hr, min: min);
  }
}

class SegmentDragToTimeChangeConverter {
  static DateTime dragInputToNewTime(DragUpdateDetails details,
      RenderBox calendarGrid, double hourSpacing, int granularity) {
    var relativeTapPos = calendarGrid.globalToLocal(details.globalPosition);
    return GridTapToTimeConverter.touchInputToTime(
        relativeTapPos, hourSpacing, granularity);
  }
}
