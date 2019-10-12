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
    print(event);
    if (event is TemporarySleepSegmentCreated) {
      DateTime t = GridTapToTimeConverter.touchInputToTime(
          event.touchCoord, event.hourPixels);
      DateTime endTime = t.add(Duration(minutes: 30));
      SleepSegment segment = SleepSegment(startTime: t, endTime: endTime);
      yield TemporarySegmentExists(segment: segment);
    } else if (event is TemporarySleepSegmentDragged) {
      final t = SegmentDragToTimeChangeConverter.dragInputToNewTime(
          event.details, event.calendarGrid, event.hourSpacing);
      var currentSegment = (currentState as TemporarySegmentExists).segment;
      if (t.compareTo(currentSegment.startTime) != 0) {
        final newSeg = SleepSegment(
            startTime: t,
            endTime:
                t.add(Duration(minutes: currentSegment.getDurationMinutes())));
        yield TemporarySegmentExists(segment: newSeg);
      }
      print(t);
    }
  }
}

class GridTapToTimeConverter {
  static DateTime touchInputToTime(Offset tapPosition, double hourSpacing) {
    // Get new segment
    var hr = tapPosition.dy / hourSpacing;
    // now check if we're in the first or second half of that hour
    int granularity = 30;
    var min = ((tapPosition.dy % hourSpacing) ~/ granularity) * 15;
    return SegmentDateTime(hr: hr.toInt(), min: min);
  }
}

class SegmentDragToTimeChangeConverter {
  // should return our new time
  static DateTime dragInputToNewTime(
      DragUpdateDetails details, RenderBox calendarGrid, double hourSpacing) {
    var relativeTapPos = calendarGrid.globalToLocal(details.globalPosition);
    var hr = relativeTapPos.dy ~/ hourSpacing;

    // now compute what 15 min block we are in
    int granularity = 15;
    var min = ((relativeTapPos.dy % hourSpacing) ~/ granularity) * 15;
    return SegmentDateTime(hr: hr, min: min);
  }
}
