import 'dart:async';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class ScheduleEditorBloc
    extends Bloc<ScheduleEditorEvent, ScheduleEditorState> {
  @override
  ScheduleEditorState get initialState => InitialScheduleEditorState();

  @override
  Stream<ScheduleEditorState> mapEventToState(
    ScheduleEditorEvent event,
  ) async* {
    // TODO: Add Logic
    print(event);
    if (event is TemporarySleepSegmentCreated) {
      var t = InputToTimeConverter.touchInputToTime(
          event.touchCoord, event.hourPixels);
      print('tap here! : ${t}');
      // should yield TempraryScheduleCreatedState
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
