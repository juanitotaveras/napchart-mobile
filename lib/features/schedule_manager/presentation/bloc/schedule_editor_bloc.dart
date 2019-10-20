import 'dart:async';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:polysleep/core/usecases/usecase.dart';
import 'package:polysleep/core/utils.dart';
import 'package:polysleep/features/schedule_manager/data/repositories/schedule_editor_repository_impl.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/get_current_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/get_default_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/save_current_schedule.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/bloc.dart'
    as prefix0;
import './bloc.dart';

class ScheduleEditorBloc
    extends Bloc<ScheduleEditorEvent, ScheduleEditorState> {
  final GetCurrentSchedule getCurrentSchedule;
  final GetDefaultSchedule getDefaultSchedule;
  final SaveCurrentSchedule saveCurrentSchedule;

  ScheduleEditorBloc(
      {@required GetCurrentSchedule getCurrentSchedule,
      @required GetDefaultSchedule getDefaultSchedule,
      @required SaveCurrentSchedule saveCurrentSchedule})
      : assert(getCurrentSchedule != null),
        assert(getDefaultSchedule != null),
        assert(saveCurrentSchedule != null),
        getCurrentSchedule = getCurrentSchedule,
        getDefaultSchedule = getDefaultSchedule,
        saveCurrentSchedule = saveCurrentSchedule;

  @override
  ScheduleEditorState get initialState => Init();

  @override
  Stream<ScheduleEditorState> mapEventToState(
    ScheduleEditorEvent event,
  ) async* {
    final eventHandlers = {
      'LoadSchedule': handleLoadSchedule,
      'TemporarySleepSegmentCreated': handleTemporarySleepSegmentCreated,
      'TemporarySleepSegmentDragged': handleTemporarySleepSegmentDragged,
      'TemporarySleepSegmentStartTimeDragged':
          handleTemporarySleepSegmentStartTimeDragged,
      'TemporarySleepSegmentEndTimeDragged':
          handleTemporarySleepSegmentEndTimeDragged,
      'SelectedSegmentCancelled': handleSelectedSegmentCancelled,
      'SelectedSegmentSaved': handleSelectedSegmentSaved,
      'SaveChangesPressed': handleSaveChangesPressed,
      'LoadedSegmentTapped': handleLoadedSegmentTapped
    };
    if (eventHandlers.containsKey(event.toString())) {
      final handler = eventHandlers[event.toString()];
      yield* handler(event);
    }
  }

  Stream<ScheduleEditorState> handleLoadSchedule(event) async* {
    final resp = await getCurrentSchedule(NoParams());
    yield* resp.fold((failure) async* {
      final defResp = await getDefaultSchedule(NoParams());
      yield* defResp.fold((failure) async* {
        yield SegmentsLoaded(loadedSegments: []);
      }, (schedule) async* {
        yield SegmentsLoaded(loadedSegments: schedule.segments);
      });
    }, (schedule) async* {
      yield SegmentsLoaded(loadedSegments: schedule.segments);
    });
  }

  Stream<ScheduleEditorState> handleTemporarySleepSegmentCreated(event) async* {
    DateTime t = GridTapToTimeConverter.touchInputToTime(
        event.touchCoord, event.hourPixels, 30);
    DateTime endTime = t.add(Duration(minutes: 60));
    SleepSegment selectedSegment = SleepSegment(startTime: t, endTime: endTime);
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
  }

  Stream<ScheduleEditorState> handleTemporarySleepSegmentDragged(event) async* {
    final state = Utils.tryCast<SegmentsLoaded>(currentState);
    if (state != null) {
      final t = GridTapToTimeConverter.touchInputToTime(
          event.touchCoord, event.hourSpacing, 15);
      SleepSegment currentSegment = state.selectedSegment;
      if (t.compareTo(currentSegment.startTime) != 0) {
        final selectedSegment = SleepSegment(
            startTime: t,
            endTime:
                t.add(Duration(minutes: currentSegment.getDurationMinutes())));
        yield SegmentsLoaded(
            selectedSegment: selectedSegment,
            loadedSegments: state.loadedSegments);
      }
    }
  }

  Stream<ScheduleEditorState> handleTemporarySleepSegmentStartTimeDragged(
      event) async* {
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
  }

  Stream<ScheduleEditorState> handleTemporarySleepSegmentEndTimeDragged(
      event) async* {
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
  }

  Stream<ScheduleEditorState> handleSaveChangesPressed(event) async* {
    final state = Utils.tryCast<SegmentsLoaded>(currentState);
    if (state != null) {
      SleepSchedule schedule = SleepSchedule(segments: state.loadedSegments);
      final resp = await saveCurrentSchedule(Params(schedule: schedule));
      yield* resp.fold((failure) async* {
        // print('there has been an error');
        // show error state
      }, (updatedSchedule) async* {
        // print(' great success!');
        print(updatedSchedule);
      });
    }
  }

  Stream<ScheduleEditorState> handleSelectedSegmentCancelled(event) async* {
    final state = Utils.tryCast<SegmentsLoaded>(currentState);
    if (state != null) {
      yield SegmentsLoaded(loadedSegments: state.loadedSegments);
    }
  }

  Stream<ScheduleEditorState> handleSelectedSegmentSaved(event) async* {
    final state = Utils.tryCast<SegmentsLoaded>(currentState);
    if (state != null) {
      yield SegmentsLoaded(
          loadedSegments: [state.selectedSegment, ...state.loadedSegments]);
    }
  }

  Stream<ScheduleEditorState> handleLoadedSegmentTapped(event) async* {
    final state = Utils.tryCast<SegmentsLoaded>(currentState);
    if (state != null) {
      // make this segment into editiing segment
      final index = (event as LoadedSegmentTapped).idx;
      // final segs = state.loadedSegments.m
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
