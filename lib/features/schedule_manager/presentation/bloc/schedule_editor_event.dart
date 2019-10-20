import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ScheduleEditorEvent extends Equatable {
  ScheduleEditorEvent([List props = const <dynamic>[]]) : super(props);
}

class LoadSchedule extends ScheduleEditorEvent {}

class TemporarySleepSegmentCreated extends ScheduleEditorEvent {
  final Offset touchCoord;
  final double hourPixels;

  TemporarySleepSegmentCreated(this.touchCoord, this.hourPixels)
      : super([touchCoord, hourPixels]);
}

class SelectedSegmentCancelled extends ScheduleEditorEvent {}

class TemporarySleepSegmentDragged extends ScheduleEditorEvent {
  final DragUpdateDetails details;
  final Offset touchCoord;
  final double hourSpacing;
  TemporarySleepSegmentDragged(this.details, this.touchCoord, this.hourSpacing)
      : super([details]);
}

class TemporarySleepSegmentStartTimeDragged extends ScheduleEditorEvent {
  final DragUpdateDetails details;
  final Offset touchCoord;
  final double hourSpacing;
  TemporarySleepSegmentStartTimeDragged(
      this.details, this.touchCoord, this.hourSpacing)
      : super([details]);
}

class TemporarySleepSegmentEndTimeDragged extends ScheduleEditorEvent {
  final DragUpdateDetails details;
  final Offset touchCoord;
  final double hourSpacing;
  TemporarySleepSegmentEndTimeDragged(
      this.details, this.touchCoord, this.hourSpacing)
      : super([details]);
}

class LoadedSegmentTapped extends ScheduleEditorEvent {
  final int idx;
  LoadedSegmentTapped(this.idx) : super([idx]);
}

class SelectedSegmentSaved extends ScheduleEditorEvent {}

class SaveChangesPressed extends ScheduleEditorEvent {}
