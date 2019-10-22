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
import 'package:rxdart/rxdart.dart';
import './bloc.dart';

// TODO: Call this a ViewModel/Presenter
// Data binding between this and view
// Another class, our Model, should store the state
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

    _eventHandlerSubject.stream.listen((ScheduleEditorEvent event) {
      print('EVENT!!! $event');
      handleEvent(event);
    });
  }

// VIEW MODEL

  final selectedSegmentSubject = BehaviorSubject<SleepSegment>();
  Stream<SleepSegment> get selectedSegmentStream =>
      selectedSegmentSubject.stream;
  StreamSink<SleepSegment> get _selectedSegmentSink =>
      selectedSegmentSubject.sink;

  final _loadedSegmentsSubject = BehaviorSubject<List<SleepSegment>>();
  Stream<List<SleepSegment>> get loadedSegmentsStream =>
      _loadedSegmentsSubject.stream;
  StreamSink<List<SleepSegment>> get _loadedSegmentsSink =>
      _loadedSegmentsSubject.sink;

// TODO: Seed with LoadSchedule so we never even have to call it
  final _eventHandlerSubject = BehaviorSubject<ScheduleEditorEvent>();

  @override
  void dispose() {
    selectedSegmentSubject.close();
    _loadedSegmentsSubject.close();
    _eventHandlerSubject.close();
    super.dispose();
  }

  void handleEvent(ScheduleEditorEvent event) async {
    // LoadSchedule
    if (event is LoadSchedule) {
      final resp = await getCurrentSchedule(NoParams());
      resp.fold((failure) async {
        final defResp = await getDefaultSchedule(NoParams());
        defResp.fold((failure) async {
          _loadedSegmentsSink.add([]);
        }, (schedule) async {
          _loadedSegmentsSink.add(schedule.segments);
        });
      }, (schedule) async {
        _loadedSegmentsSink.add(schedule.segments);
      });
    }

    // TemporarySegmentCreated
    else if (event is TemporarySleepSegmentCreated) {
      DateTime t = GridTapToTimeConverter.touchInputToTime(
          event.touchCoord, event.hourPixels, 30);
      CreateTemporarySleepSegment usecase = CreateTemporarySleepSegment();
      DateTime endTime = t.add(Duration(minutes: 60));
      SleepSegment selectedSegment =
          SleepSegment(startTime: t, endTime: endTime);
      selectedSegmentSubject.add(selectedSegment);
    }

    // TemporarySleepSegmentDragged
    else if (event is TemporarySleepSegmentDragged) {
      final t = GridTapToTimeConverter.touchInputToTime(
          event.touchCoord, event.hourSpacing, 15);
      SleepSegment currentSegment = selectedSegmentSubject.value;
      if (t.compareTo(currentSegment.startTime) != 0) {
        final selectedSegment = SleepSegment(
            startTime: t,
            endTime:
                t.add(Duration(minutes: currentSegment.getDurationMinutes())));
        selectedSegmentSubject.add(selectedSegment);
      }
    }

    // Temporary Sleep SEgment Start Time Dragged
    else if (event is TemporarySleepSegmentStartTimeDragged) {
      final t = GridTapToTimeConverter.touchInputToTime(
          event.touchCoord, event.hourSpacing, 5);
      SleepSegment currentSegment = selectedSegmentSubject.value;
      if (t.compareTo(currentSegment.startTime) != 0) {
        final newSeg =
            SleepSegment(startTime: t, endTime: currentSegment.endTime);
        selectedSegmentSubject.add(newSeg);
      }
    }

    // end time dragged
    else if (event is TemporarySleepSegmentEndTimeDragged) {
      final t = GridTapToTimeConverter.touchInputToTime(
          event.touchCoord, event.hourSpacing, 5);
      SleepSegment currentSegment = selectedSegmentSubject.value;
      if (t.compareTo(currentSegment.startTime) != 0) {
        final newSeg =
            SleepSegment(startTime: currentSegment.startTime, endTime: t);
        selectedSegmentSubject.add(newSeg);
      }
    }

    // save changes pressed
    else if (event is SaveChangesPressed) {
      SleepSchedule schedule =
          SleepSchedule(segments: _loadedSegmentsSubject.value);
      final resp = await saveCurrentSchedule(Params(schedule: schedule));
      resp.fold((failure) async {
        // print('there has been an error');
        // show error state
      }, (updatedSchedule) async {
        // print(' great success!');
        print(updatedSchedule);
      });
    }
  }

  @override
  ScheduleEditorState get initialState => Init();

  @override
  void dispatch(ScheduleEditorEvent event) {
    // TODO: implement dispatch
    _eventHandlerSubject.add(event);
    // print('LE DISPATCH: $event');
    super.dispatch(event);
  }

  @override
  Stream<ScheduleEditorState> mapEventToState(
    ScheduleEditorEvent event,
  ) async* {
    final eventHandlers = {
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
        _loadedSegmentsSink.add([]);
        yield SegmentsLoaded(loadedSegments: []);
      }, (schedule) async* {
        _loadedSegmentsSink.add(schedule.segments);
        yield SegmentsLoaded(loadedSegments: schedule.segments);
      });
    }, (schedule) async* {
      _loadedSegmentsSink.add(schedule.segments);
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
    // if (state != null) {
    // yield SegmentsLoaded(
    //     selectedSegment: selectedSegment,
    //     loadedSegments: state.loadedSegments);
    selectedSegmentSubject.add(selectedSegment);
    print('adding to insegment');
    yield usecase(state, t);
    // }
  }

  Stream<ScheduleEditorState> handleSaveChangesPressed(event) async* {
    final state = Utils.tryCast<SegmentsLoaded>(currentState);
    if (state != null) {}
  }

  Stream<ScheduleEditorState> handleSelectedSegmentCancelled(event) async* {
    final state = Utils.tryCast<SegmentsLoaded>(currentState);
    if (state != null) {
      // If there is an element being edited, revert it back to its previous state
      final currentlyEditing =
          state.loadedSegments.where((seg) => seg.isBeingEdited).toList();
      if (currentlyEditing.length == 0) {
        _loadedSegmentsSink.add([...state.loadedSegments]);
        selectedSegmentSubject.add(null);
        final l = selectedSegmentSubject.value;
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
      _loadedSegmentsSink.add(segs);
      selectedSegmentSubject.add(null);
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
        _loadedSegmentsSink
            .add([...state.loadedSegments, state.selectedSegment]);
        selectedSegmentSubject.add(null);
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
      _loadedSegmentsSink.add(segs);
      selectedSegmentSubject.add(null);
      yield SegmentsLoaded(loadedSegments: segs, selectedSegment: null);
    }
  }

  Stream<ScheduleEditorState> handleLoadedSegmentTapped(event) async* {
    print('LOADED SEGMENT TAPPED');
    final state = Utils.tryCast<SegmentsLoaded>(currentState);
    if (state != null) {
      // make this segment into editiing segment
      final index = (event as LoadedSegmentTapped).idx;
      // final lastSegs = await loadedSegments.last;
      // TODO: Consider putting current state in repository, like an in-memory DB
      // It might make sense for the repository to store state
      // PROBLEM: How will we access the current state?!
      // final currentSegments = selectedSegmentSubject.v
      final segs = _loadedSegmentsSubject.value
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
      _loadedSegmentsSink.add(segs);
      selectedSegmentSubject.add(selectedSegment);
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
