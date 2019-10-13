import 'package:equatable/equatable.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:meta/meta.dart';

abstract class ScheduleEditorState extends Equatable {
  ScheduleEditorState([List props = const <dynamic>[]]) : super(props);
}

class InitialScheduleEditorState extends ScheduleEditorState {
  @override
  List<Object> get props => [];
}

class TemporarySegmentCreated extends ScheduleEditorState {
  final SleepSegment segment;

  TemporarySegmentCreated({@required this.segment}) : super([segment]);
}

class SelectedSegmentChanged extends ScheduleEditorState {
  final SleepSegment segment;
  SelectedSegmentChanged({@required this.segment}) : super([segment]);
}

class SegmentsLoaded extends ScheduleEditorState {
  final List<SleepSegment> segments;
  SegmentsLoaded({@required this.segments}) : super([segments]);
}
