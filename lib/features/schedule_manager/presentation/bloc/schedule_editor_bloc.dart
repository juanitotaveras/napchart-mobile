import 'dart:async';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import './bloc.dart';

class ScheduleEditorBloc
    extends Bloc<ScheduleEditorEvent, ScheduleEditorState> {
  @override
  ScheduleEditorState get initialState => InitialScheduleEditorState();

  @override
  Stream<ScheduleEditorState> mapEventToState(
    ScheduleEditorEvent event,
  ) async* {
    print(event);
    if (event is TemporarySleepSegmentCreated) {
      DateTime t = InputToTimeConverter.touchInputToTime(
          event.touchCoord, event.hourPixels);
      DateTime endTime = t.add(Duration(minutes: 30));
      SleepSegment segment = SleepSegment(startTime: t, endTime: endTime);
      yield TemporarySegmentExists(segment: segment);
    }
  }
}

class InputToTimeConverter {
  static DateTime touchInputToTime(Offset tapPosition, double hourSpacing) {
    // Get new segment
    var hr = tapPosition.dy / hourSpacing;
    // now check if we're in the first or second half of that hour
    var part = (hr - (hr.toInt()));
    var min = (part < 0.5) ? 0 : 30;
    return DateTime(2020, 1, 1, hr.toInt(), min);
  }
}
