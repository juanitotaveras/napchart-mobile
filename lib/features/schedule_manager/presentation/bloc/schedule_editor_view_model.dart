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

class ScheduleEditorViewModel implements ViewModelBase {
  final GetCurrentOrDefaultSchedule getCurrentOrDefaultSchedule;
  final SaveCurrentSchedule saveCurrentSchedule;

//! streams

  final selectedSegmentSubject = BehaviorSubject<SleepSegment>();
  Stream<SleepSegment> get selectedSegmentStream =>
      selectedSegmentSubject.stream;
  SleepSegment get selectedSegment => selectedSegmentSubject.value;

  final loadedScheduleSubject = BehaviorSubject<SleepSchedule>();
  Stream<SleepSchedule> get loadedScheduleStream =>
      loadedScheduleSubject.stream;
  SleepSchedule get loadedSchedule => loadedScheduleSubject.value;

  final _unsavedChangesExistStreamController =
      StreamController<bool>.broadcast();
  Stream<bool> get unsavedChangesExistStream =>
      _unsavedChangesExistStreamController.stream.distinct();

  var isDragging = false;
  // Difference between start time of selected segment and
  // the point at which we started dragging
  Duration startDragDiffTime;

  // This is used to revert our state if we have created a new segment
  // but then cancelled
  SleepSegment previousSelectedSegment;

  SleepSchedule initialSchedule;

  ScheduleEditorViewModel(
      {@required this.getCurrentOrDefaultSchedule,
      @required this.saveCurrentSchedule}) {
    assert(getCurrentOrDefaultSchedule != null);
    assert(saveCurrentSchedule != null);

    loadedScheduleStream.listen((SleepSchedule data) {
      if (this.initialSchedule != null) {
        // Only add to stream if vals are different
        final areDifferent = this.initialSchedule.hasDifferentSegments(data);
        _unsavedChangesExistStreamController.sink.add(areDifferent);
      }

      // append to our selectedSegmentStream
      if (this.loadedSchedule != null &&
          this.selectedSegment != this.loadedSchedule.getSelectedSegment()) {
        this
            .selectedSegmentSubject
            .add(this.loadedSchedule.getSelectedSegment());
      }
    });
  }

  void dispose() {
    selectedSegmentSubject.close();
    loadedScheduleSubject.close();
    _unsavedChangesExistStreamController.close();
  }

  /// ---------------   START EVENT HANDLERS
  onLoadSchedule() async {
    final resp = await getCurrentOrDefaultSchedule(NoParams());
    resp.fold((failure) async {
      loadedScheduleSubject.add(null);
    }, (schedule) async {
      loadedScheduleSubject.add(schedule);
      initialSchedule = schedule;
    });
  }

  onTemporarySegmentCreated(Offset touchCoord, double hourPixels) {
    DateTime t =
        GridTapToTimeConverter.touchInputToTime(touchCoord, hourPixels, 30);
    DateTime endTime = t.add(Duration(minutes: 60));
    final prevSegments =
        loadedSchedule.segments.map((seg) => seg.clone(isSelected: false));
    final tempSegment =
        SleepSegment(startTime: t, endTime: endTime, isSelected: true);
    loadedScheduleSubject
        .add(loadedSchedule.clone(segments: [...prevSegments, tempSegment]));
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
    final newEndTime = newStartTime
        .add(Duration(minutes: selectedSegment.getDurationMinutes()));
    final newSegments = loadedSchedule.segments.map((seg) {
      if (!seg.isSelected) return seg;
      return seg.clone(startTime: newStartTime, endTime: newEndTime);
    }).toList();
    loadedScheduleSubject.add(loadedSchedule.clone(segments: newSegments));
  }

  onSelectedSleepSegmentEndDrag() {
    this.startDragDiffTime = null;
  }

  onSelectedSegmentStartTimeDragged(Offset touchCoord, double hourSpacing) {
    final t =
        GridTapToTimeConverter.touchInputToTime(touchCoord, hourSpacing, 5);
    SleepSegment currentSegment = loadedSchedule.getSelectedSegment();
    if (t.compareTo(currentSegment.startTime) != 0) {
      final newSeg =
          currentSegment.clone(startTime: t, endTime: currentSegment.endTime);
      final newSegments = loadedSchedule.segments
          .map((seg) => (!seg.isSelected) ? seg : newSeg)
          .toList();
      loadedScheduleSubject.add(loadedSchedule.clone(segments: newSegments));
    }
  }

  onSelectedSegmentEndTimeDragged(Offset touchCoord, double hourSpacing) {
    final t =
        GridTapToTimeConverter.touchInputToTime(touchCoord, hourSpacing, 5);
    SleepSegment currentSegment = selectedSegment;
    if (t.compareTo(currentSegment.startTime) != 0) {
      final newSeg =
          currentSegment.clone(startTime: currentSegment.startTime, endTime: t);
      final newSegments = loadedSchedule.segments
          .map((seg) => (!seg.isSelected) ? seg : newSeg)
          .toList();
      loadedScheduleSubject.add(loadedSchedule.clone(segments: newSegments));
    }
  }

  onSaveChangesPressed() async {
    final resp =
        await saveCurrentSchedule(Params(schedule: this.loadedSchedule));
    resp.fold((failure) async {
      // print('there has been an error');
      // show error state
    }, (updatedSchedule) async {
      this.initialSchedule = updatedSchedule;
      this.loadedScheduleSubject.add(updatedSchedule);
    });
  }

  onSelectedSegmentCancelled() async {
    if (this.previousSelectedSegment == null) {
      final newSegs =
          loadedSchedule.segments.where((seg) => !seg.isSelected).toList();
      loadedScheduleSubject.add(loadedSchedule.clone(segments: newSegs));
    } else {
      final newSegs = loadedSchedule.segments
          .map((seg) => seg.isSelected ? this.previousSelectedSegment : seg)
          .toList();
      loadedScheduleSubject.add(loadedSchedule.clone(segments: newSegs));
      this.previousSelectedSegment = null;
    }
  }

  onLoadedSegmentTapped(int index) async {
    this.previousSelectedSegment = loadedSchedule.segments[index];
    final segs = loadedSchedule.segments
        .asMap()
        .map((idx, seg) => MapEntry(idx, seg.clone(isSelected: idx == index)))
        .values
        .toList();
    loadedScheduleSubject.add(loadedSchedule.clone(segments: segs));
  }

  onSelectedSegmentSaved() {
    final newSegs = loadedSchedule.segments
        .map((seg) => !seg.isSelected ? seg : seg.clone(isSelected: false))
        .toList();
    loadedScheduleSubject.add(loadedSchedule.clone(segments: newSegs));
  }

  onDeleteSelectedSegmentPressed() {
    final remainingSegments =
        loadedSchedule.segments.where((seg) => !seg.isSelected).toList();
    loadedScheduleSubject
        .add(loadedSchedule.clone(segments: remainingSegments));
  }

  onTemplateScheduleSet(SleepSchedule schedule) {
    loadedScheduleSubject.add(schedule);
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
