import 'dart:ui';

import 'package:equatable/equatable.dart';

abstract class ScheduleEditorEvent extends Equatable {
  ScheduleEditorEvent([List props = const <dynamic>[]]) : super(props);
}

class TemporarySleepSegmentCreated extends ScheduleEditorEvent {
  final Offset touchCoord;
  final double hourPixels;

  TemporarySleepSegmentCreated(this.touchCoord, this.hourPixels)
      : super([touchCoord, hourPixels]);
}
