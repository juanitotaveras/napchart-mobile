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
      yield TemporarySegmentCreated(segment: segment);
    } else if (event is TemporarySleepSegmentDragged) {
      final t = SegmentDragToTimeChangeConverter.dragInputToNewTime(
          event.details, event.calendarGrid, event.hourSpacing, 15);
      SleepSegment currentSegment = (currentState as dynamic).segment;
      if (t.compareTo(currentSegment.startTime) != 0) {
        final newSeg = SleepSegment(
            startTime: t,
            endTime:
                t.add(Duration(minutes: currentSegment.getDurationMinutes())));
        yield SelectedSegmentChanged(segment: newSeg);
      }
    } else if (event is TemporarySleepSegmentStartTimeDragged) {
      final t = SegmentDragToTimeChangeConverter.dragInputToNewTime(
          event.details, event.calendarGrid, event.hourSpacing, 5);
      SleepSegment currentSegment = (currentState as dynamic).segment;
      if (t.compareTo(currentSegment.startTime) != 0) {
        print('start time: ${t} end time: ${currentSegment.endTime}');
        final newSeg =
            SleepSegment(startTime: t, endTime: currentSegment.endTime);
        yield SelectedSegmentChanged(segment: newSeg);
      }
    } else if (event is TemporarySleepSegmentEndTimeDragged) {
      print('le end time dragged: ${event.details}');
      final t = SegmentDragToTimeChangeConverter.dragInputToNewTime(
          event.details, event.calendarGrid, event.hourSpacing, 5);
      SleepSegment currentSegment = (currentState as dynamic).segment;
      if (t.compareTo(currentSegment.startTime) != 0) {
        final newSeg =
            SleepSegment(startTime: currentSegment.startTime, endTime: t);
        yield SelectedSegmentChanged(segment: newSeg);
      }
    } else if (event is SelectedSegmentCancelled) {
      print('SELECTED SEGMENT CANCELLED BABIES');
      yield InitialScheduleEditorState();
    } else if (event is SelectedSegmentSaved) {
      print('omg we save up');
      final SleepSegment savedSegment = (currentState as dynamic).segment;
      yield SegmentsLoaded(segments: [savedSegment]);
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
