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

class TemporarySleepSegmentDragged extends ScheduleEditorEvent {
  final DragUpdateDetails details;
  final RenderBox calendarGrid;
  final double hourSpacing;
  TemporarySleepSegmentDragged(
      this.details, this.calendarGrid, this.hourSpacing)
      : super([details]);
}
