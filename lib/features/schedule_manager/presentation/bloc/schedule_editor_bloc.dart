import 'dart:async';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:polysleep/core/constants.dart';
import 'package:polysleep/core/usecases/usecase.dart';
import 'package:polysleep/core/utils.dart';
import 'package:polysleep/features/schedule_manager/data/repositories/schedule_editor_repository_impl.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/get_current_or_default_schedule.dart';
// import 'package:polysleep/features/schedule_manager/domain/usecases/create_temporary_segment.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/save_current_schedule.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/view_model_provider.dart';
import 'package:rxdart/rxdart.dart';

class ScheduleEditorBloc implements ViewModelBase {
  final GetCurrentOrDefaultSchedule getCurrentOrDefaultSchedule;
  final SaveCurrentSchedule saveCurrentSchedule;

  ScheduleEditorBloc(
      {@required this.getCurrentOrDefaultSchedule,
      @required this.saveCurrentSchedule}) {
    assert(getCurrentOrDefaultSchedule != null);
    assert(saveCurrentSchedule != null);
  }

//! streams
  final selectedSegmentSubject = BehaviorSubject<SleepSegment>();
  Stream<SleepSegment> get selectedSegmentStream =>
      selectedSegmentSubject.stream;
  SleepSegment get selectedSegment => selectedSegmentSubject.value;

  final loadedSegmentsSubject = BehaviorSubject<List<SleepSegment>>();
  Stream<List<SleepSegment>> get loadedSegmentsStream =>
      loadedSegmentsSubject.stream;
  List<SleepSegment> get loadedSegments => loadedSegmentsSubject.value;

  var isDragging = false;
  // Difference between start time of selected segment and
  // the point at which we started dragging
  Duration startDragDiffTime;

  void dispose() {
    selectedSegmentSubject.close();
    loadedSegmentsSubject.close();
  }

  /// ---------------   START EVENT HANDLERS
  onLoadSchedule() async {
    final resp = await getCurrentOrDefaultSchedule(NoParams());
    resp.fold((failure) async {
      loadedSegmentsSubject.add([]);
    }, (schedule) async {
      loadedSegmentsSubject.add(schedule.segments);
    });
  }

  onTemporarySegmentCreated(Offset touchCoord, double hourPixels) {
    DateTime t =
        GridTapToTimeConverter.touchInputToTime(touchCoord, hourPixels, 30);
    DateTime endTime = t.add(Duration(minutes: 60));
    selectedSegmentSubject.add(SleepSegment(startTime: t, endTime: endTime));
  }

  onSelectedSegmentStartDrag(Offset touchCoord, double hourSpacing) {
    final t =
        GridTapToTimeConverter.touchInputToTime(touchCoord, hourSpacing, 15);
    this.startDragDiffTime = this.selectedSegment.startTime.difference(t).abs();
  }

  onSelectedSegmentEndSectionStartDrag(Offset touchCoord, double hourSpacing) {
    // onSelectedSegmentStartDrag(touchCoord, hourSpacing);
    final t =
        GridTapToTimeConverter.touchInputToTime(touchCoord, hourSpacing, 15);
    // if (t.isBefore(this.selectedSegment.startTime)) {
    // get minutes from midnight to now, and start to midnight

    final Duration min = t.difference(SegmentDateTime(hr: 0, min: 0));
    final Duration min2 = min +
        Duration(
            minutes: MINUTES_PER_DAY -
                this.selectedSegment.getStartMinutesFromMidnight());
    this.startDragDiffTime =
        min2; //this.selectedSegment.startTime.difference(t).abs();
  }

  onSelectedSleepSegmentDragged(Offset touchCoord, double hourSpacing) {
    final t =
        GridTapToTimeConverter.touchInputToTime(touchCoord, hourSpacing, 15);
    final newStartTime = t.subtract(startDragDiffTime);
    final newSeg = SleepSegment(
        startTime: newStartTime,
        endTime: newStartTime
            .add(Duration(minutes: selectedSegment.getDurationMinutes())));
    selectedSegmentSubject.add(newSeg);
  }

  onSelectedSleepSegmentEndDrag() {
    this.startDragDiffTime = null;
  }

  onSelectedSegmentStartTimeDragged(Offset touchCoord, double hourSpacing) {
    final t =
        GridTapToTimeConverter.touchInputToTime(touchCoord, hourSpacing, 5);
    SleepSegment currentSegment = selectedSegment;
    if (t.compareTo(currentSegment.startTime) != 0) {
      final newSeg =
          SleepSegment(startTime: t, endTime: currentSegment.endTime);
      selectedSegmentSubject.add(newSeg);
    }
  }

  onSelectedSegmentEndTimeDragged(Offset touchCoord, double hourSpacing) {
    final t =
        GridTapToTimeConverter.touchInputToTime(touchCoord, hourSpacing, 5);
    SleepSegment currentSegment = selectedSegment;
    if (t.compareTo(currentSegment.startTime) != 0) {
      final newSeg =
          SleepSegment(startTime: currentSegment.startTime, endTime: t);
      selectedSegmentSubject.add(newSeg);
    }
  }

  onSaveChangesPressed() async {
    SleepSchedule schedule = SleepSchedule(segments: loadedSegments);
    final resp = await saveCurrentSchedule(Params(schedule: schedule));
    resp.fold((failure) async {
      // print('there has been an error');
      // show error state
    }, (updatedSchedule) async {
      // print(' great success!');
      print(updatedSchedule);
      // currentScheduleSubject.add(schedule);
    });
  }

  onSelectedSegmentCancelled() async {
    final lSegments = loadedSegments;
    final currentlyEditing = lSegments.where((seg) => seg.isSelected).toList();
    if (currentlyEditing.length == 0) {
      loadedSegmentsSubject.add([...lSegments]);
      selectedSegmentSubject.add(null);
    } else {
      final segs = lSegments
          .map((seg) => SleepSegment(
              startTime: seg.startTime,
              endTime: seg.endTime,
              isSelected: false,
              name: seg.name))
          .toList();
      loadedSegmentsSubject.add(segs);
      selectedSegmentSubject.add(null);
    }
  }

  onLoadedSegmentTapped(int index) async {
    final segs = loadedSegments
        .asMap()
        .map((idx, seg) {
          return MapEntry(
              idx,
              SleepSegment(
                  startTime: seg.startTime,
                  endTime: seg.endTime,
                  name: seg.name,
                  isSelected: idx == index));
        })
        .values
        .toList();
    final selectedSegment = segs.where((seg) => seg.isSelected).toList()[0];
    loadedSegmentsSubject.add(segs);
    selectedSegmentSubject.add(selectedSegment);
  }

  onSelectedSegmentSaved() {
    final lSegments = loadedSegments;
    final sSegment = selectedSegment;
    final currentlyEdited = lSegments.where((seg) => seg.isSelected).toList();
    if (currentlyEdited.length == 0) {
      // this is a new segment
      loadedSegmentsSubject.add([...lSegments, sSegment]);
      selectedSegmentSubject.add(null);
    } else {
      final segs = lSegments.map((seg) {
        if (seg.isSelected) {
          final sel = sSegment;
          return SleepSegment(
              startTime: sel.startTime,
              endTime: sel.endTime,
              name: sel.name,
              isSelected: false);
        }
        return SleepSegment(
            startTime: seg.startTime,
            endTime: seg.endTime,
            name: seg.name,
            isSelected: false);
      }).toList();
      loadedSegmentsSubject.add(segs);
      selectedSegmentSubject.add(null);
    }
  }

  onDeleteSelectedSegmentPressed() {
    final remainingSegments =
        loadedSegments.where((seg) => !seg.isSelected).toList();
    loadedSegmentsSubject.add(remainingSegments);
    selectedSegmentSubject.add(null);
  }

  onTemplateScheduleSet(SleepSchedule schedule) {
    loadedSegmentsSubject.add(schedule.segments);
    selectedSegmentSubject.add(null);
  }

  /// ---------------   END EVENT HANDLERS
}

// TODO: Put these into an EventMapper class
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
