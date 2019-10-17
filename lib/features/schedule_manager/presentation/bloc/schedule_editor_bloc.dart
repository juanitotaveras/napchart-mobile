import 'dart:async';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:polysleep/core/utils.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import './bloc.dart';

class ScheduleEditorBloc
    extends Bloc<ScheduleEditorEvent, ScheduleEditorState> {
  @override
  ScheduleEditorState get initialState => Init();

  @override
  Stream<ScheduleEditorState> mapEventToState(
    ScheduleEditorEvent event,
  ) async* {
    if (event is LoadSchedule) {
      print('LOAD SCHEDULE EVENT RECEIVED');
      /*
      loadedSegments = await loadSegments();
      yield SegmentsLoaded(loadedSegments: loadedSegments);
      */
      return;
    }

    if (event is TemporarySleepSegmentCreated) {
      DateTime t = GridTapToTimeConverter.touchInputToTime(
          event.touchCoord, event.hourPixels, 30);
      DateTime endTime = t.add(Duration(minutes: 60));
      SleepSegment selectedSegment =
          SleepSegment(startTime: t, endTime: endTime);
      final state = Utils.tryCast<SegmentsLoaded>(currentState);
      if (state != null) {
        yield SegmentsLoaded(
            selectedSegment: selectedSegment,
            loadedSegments: state.loadedSegments);
      } else {
        // temporary
        yield SegmentsLoaded(
            loadedSegments: [], selectedSegment: selectedSegment);
      }
      return;
    }

    if (event is TemporarySleepSegmentDragged) {
      final state = Utils.tryCast<SegmentsLoaded>(currentState);
      if (state != null) {
        // print('state not null here');
        // final t = SegmentDragToTimeChangeConverter.dragInputToNewTime(
        //     event.details, event.calendarGrid, event.hourSpacing, 15);
        final t = GridTapToTimeConverter.touchInputToTime(
            event.touchCoord, event.hourSpacing, 15);
        SleepSegment currentSegment = state.selectedSegment;
        if (t.compareTo(currentSegment.startTime) != 0) {
          final selectedSegment = SleepSegment(
              startTime: t,
              endTime: t
                  .add(Duration(minutes: currentSegment.getDurationMinutes())));
          yield SegmentsLoaded(
              selectedSegment: selectedSegment,
              loadedSegments: state.loadedSegments);
        }
      }
      return;
    }

    if (event is TemporarySleepSegmentStartTimeDragged) {
      final state = Utils.tryCast<SegmentsLoaded>(currentState);
      if (state != null) {
        final t = GridTapToTimeConverter.touchInputToTime(
            event.touchCoord, event.hourSpacing, 5);
        SleepSegment currentSegment = state.selectedSegment;
        if (t.compareTo(currentSegment.startTime) != 0) {
          final newSeg =
              SleepSegment(startTime: t, endTime: currentSegment.endTime);
          yield SegmentsLoaded(
              selectedSegment: newSeg, loadedSegments: state.loadedSegments);
        }
      }
      return;
    }

    if (event is TemporarySleepSegmentEndTimeDragged) {
      final state = Utils.tryCast<SegmentsLoaded>(currentState);
      if (state != null) {
        final t = GridTapToTimeConverter.touchInputToTime(
            event.touchCoord, event.hourSpacing, 5);
        SleepSegment currentSegment = state.selectedSegment;
        if (t.compareTo(currentSegment.startTime) != 0) {
          final newSeg =
              SleepSegment(startTime: currentSegment.startTime, endTime: t);
          yield SegmentsLoaded(
              selectedSegment: newSeg, loadedSegments: state.loadedSegments);
        }
      }
      return;
    }

    if (event is SelectedSegmentCancelled) {
      final state = Utils.tryCast<SegmentsLoaded>(currentState);
      if (state != null) {
        yield SegmentsLoaded(loadedSegments: state.loadedSegments);
      }
      return;
    }

    if (event is SelectedSegmentSaved) {
      final state = Utils.tryCast<SegmentsLoaded>(currentState);
      if (state != null) {
        yield SegmentsLoaded(
            loadedSegments: [state.selectedSegment, ...state.loadedSegments]);
      }
      return;
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
    assert(calendarGrid != null);
    var relativeTapPos = calendarGrid.globalToLocal(details.globalPosition);
    return GridTapToTimeConverter.touchInputToTime(
        relativeTapPos, hourSpacing, granularity);
  }
}
