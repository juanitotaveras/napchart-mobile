import 'package:equatable/equatable.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:meta/meta.dart';

abstract class ScheduleEditorState extends Equatable {
  ScheduleEditorState([List props = const <dynamic>[]]) : super(props);
}

class Init extends ScheduleEditorState {
  @override
  List<Object> get props => [];
}

class Loading extends ScheduleEditorState {}

class TemporarySegmentCreated extends ScheduleEditorState {
  final SleepSegment selectedSegment;
  final List<SleepSegment> loadedSegments;
  // TODO: Check if selectedSegment is new or not
  // Mark the segment in loadedsegments that is being edited
  TemporarySegmentCreated(
      {@required this.selectedSegment, @required this.loadedSegments})
      : super([selectedSegment]);
}

class SelectedSegmentChanged extends ScheduleEditorState {
  final SleepSegment selectedSegment;
  final List<SleepSegment> loadedSegments;
  SelectedSegmentChanged(
      {@required this.selectedSegment, @required this.loadedSegments})
      : super([selectedSegment]);
}

class SegmentsLoaded extends ScheduleEditorState {
  final SleepSegment selectedSegment;
  final List<SleepSegment> loadedSegments;
  SegmentsLoaded({@required this.loadedSegments, this.selectedSegment})
      : super([loadedSegments, selectedSegment]);
}
