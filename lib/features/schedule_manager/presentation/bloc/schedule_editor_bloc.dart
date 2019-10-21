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
// import 'package:polysleep/features/schedule_manager/domain/usecases/create_temporary_segment.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/get_current_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/get_default_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/save_current_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/create_temporary_segment.dart';
import './bloc.dart';

class ScheduleEditorBloc
    extends Bloc<ScheduleEditorEvent, ScheduleEditorState> {
  final GetCurrentSchedule getCurrentSchedule;
  final GetDefaultSchedule getDefaultSchedule;
  final SaveCurrentSchedule saveCurrentSchedule;

  ScheduleEditorBloc(
      {@required this.getCurrentSchedule,
      @required this.getDefaultSchedule,
      @required this.saveCurrentSchedule}) {
    assert(getCurrentSchedule != null);
    assert(getDefaultSchedule != null);
    assert(saveCurrentSchedule != null);
  }

  final _selectedSegmentStreamController =
      StreamController<SleepSegment>.broadcast();
  Stream<SleepSegment> get selectedSegment =>
      _selectedSegmentStreamController.stream.asBroadcastStream();
  StreamSink<SleepSegment> get _inSegment =>
      _selectedSegmentStreamController.sink;

  final _loadedSegmentsStreamController =
      StreamController<List<SleepSegment>>.broadcast();
  Stream<List<SleepSegment>> get loadedSegments =>
      _loadedSegmentsStreamController.stream.asBroadcastStream();
  StreamSink<List<SleepSegment>> get _inLoaded =>
      _loadedSegmentsStreamController.sink;

  @override
  void dispose() {
    _selectedSegmentStreamController.close();
    _loadedSegmentsStreamController.close();
    super.dispose();
  }

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

  /*
Question: Can the use case get the current state and compute output state?
So use case doesn't need to call the repository if everything is in memory, right?

USE CASE for temporarySleepSegmentCreated:
input: selectedSegment, loadedSegments  // prev state, action
output: SleepSchedule entity
  */

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
    /*
TEST
        */
    // CreateTemporarySleepSegment(Params(segment: null, currentSchedule: []));
    CreateTemporarySleepSegment usecase = CreateTemporarySleepSegment();
    DateTime endTime = t.add(Duration(minutes: 60));
    SleepSegment selectedSegment = SleepSegment(startTime: t, endTime: endTime);
    final state = Utils.tryCast<SegmentsLoaded>(currentState);
    if (state != null) {
      // yield SegmentsLoaded(
      //     selectedSegment: selectedSegment,
      //     loadedSegments: state.loadedSegments);
      _inSegment.add(selectedSegment);
      yield usecase(state, t);
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
        _inSegment.add(selectedSegment);
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
        _inSegment.add(newSeg);
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
        _inSegment.add(newSeg);
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
      // If there is an element being edited, revert it back to its previous state
      final currentlyEditing =
          state.loadedSegments.where((seg) => seg.isBeingEdited).toList();
      if (currentlyEditing.length == 0) {
        yield SegmentsLoaded(loadedSegments: [...state.loadedSegments]);
        return;
      }
      final segs = state.loadedSegments
          .map((seg) => SleepSegment(
              startTime: seg.startTime,
              endTime: seg.endTime,
              isBeingEdited: false,
              name: seg.name))
          .toList();
      yield SegmentsLoaded(loadedSegments: segs, selectedSegment: null);
    }
  }

  Stream<ScheduleEditorState> handleSelectedSegmentSaved(event) async* {
    final state = Utils.tryCast<SegmentsLoaded>(currentState);
    if (state != null) {
      // If no elements are being edited, this is a new segment
      final currentlyEdited =
          state.loadedSegments.where((seg) => seg.isBeingEdited).toList();
      if (currentlyEdited.length == 0) {
        // this is a new segment
        yield SegmentsLoaded(
            loadedSegments: [...state.loadedSegments, state.selectedSegment]);
        return;
      }
      final segs = state.loadedSegments.map((seg) {
        if (seg.isBeingEdited) {
          final sel = state.selectedSegment;
          return SleepSegment(
              startTime: sel.startTime,
              endTime: sel.endTime,
              name: sel.name,
              isBeingEdited: false);
        }
        return SleepSegment(
            startTime: seg.startTime,
            endTime: seg.endTime,
            name: seg.name,
            isBeingEdited: false);
      }).toList();

      yield SegmentsLoaded(loadedSegments: segs, selectedSegment: null);
    }
  }

  Stream<ScheduleEditorState> handleLoadedSegmentTapped(event) async* {
    final state = Utils.tryCast<SegmentsLoaded>(currentState);
    if (state != null) {
      // make this segment into editiing segment
      final index = (event as LoadedSegmentTapped).idx;
      final segs = state.loadedSegments
          .asMap()
          .map((idx, seg) {
            return MapEntry(
                idx,
                SleepSegment(
                    startTime: seg.startTime,
                    endTime: seg.endTime,
                    name: seg.name,
                    isBeingEdited: idx == index));
          })
          .values
          .toList();
      final selectedSegment =
          segs.where((seg) => seg.isBeingEdited).toList()[0];
      yield SegmentsLoaded(
          loadedSegments: segs, selectedSegment: selectedSegment);
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
