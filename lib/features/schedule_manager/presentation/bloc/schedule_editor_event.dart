import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ScheduleEditorEvent extends Equatable {
  ScheduleEditorEvent([List props = const <dynamic>[]]) : super(props);
}

class TemporarySleepSegmentCreated extends ScheduleEditorEvent {
  final Offset touchCoord;
  final double hourPixels;

  TemporarySleepSegmentCreated(this.touchCoord, this.hourPixels)
      : super([touchCoord, hourPixels]);
}

class SelectedSegmentChanged extends ScheduleEditorEvent {
  final Offset touchCoord;
  final double hourPixels;

  SelectedSegmentChanged(this.touchCoord, this.hourPixels)
      : super([touchCoord, hourPixels]);
}

class SelectedSegmentCancelled extends ScheduleEditorEvent {}

class TemporarySleepSegmentDragged extends ScheduleEditorEvent {
  final DragUpdateDetails details;
  final RenderBox calendarGrid;
  final double hourSpacing;
  TemporarySleepSegmentDragged(
      this.details, this.calendarGrid, this.hourSpacing)
      : super([details]);
}

class TemporarySleepSegmentStartTimeDragged extends ScheduleEditorEvent {
  final DragUpdateDetails details;
  final RenderBox calendarGrid;
  final double hourSpacing;
  TemporarySleepSegmentStartTimeDragged(
      this.details, this.calendarGrid, this.hourSpacing)
      : super([details]);
}

class TemporarySleepSegmentEndTimeDragged extends ScheduleEditorEvent {
  final DragUpdateDetails details;
  final RenderBox calendarGrid;
  final double hourSpacing;
  TemporarySleepSegmentEndTimeDragged(
      this.details, this.calendarGrid, this.hourSpacing)
      : super([details]);
}
