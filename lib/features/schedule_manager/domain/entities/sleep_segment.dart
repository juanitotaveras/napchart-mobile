import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class SleepSegment extends Equatable {
  final DateTime startTime;
  final DateTime endTime;
  // TODO: Assert that startTime < endTime
  //      : super([startTime, endTime]);
  SleepSegment({@required this.startTime, @required this.endTime}) {
    // super([this.startTime, this.endTime]);
    assert(this.endTime.isAfter(this.startTime));
  }

  int getStartMinutesFromMidnight() {
    return startTime.hour * 60 + startTime.minute;
  }

  int getEndMinutesFromMidnight() {
    return endTime.hour * 60 + endTime.minute;
  }

  bool startAndEndsOnSameDay() {
    return startTime.day == endTime.day;
  }

  int getDurationMinutes() {
    // TODO: Fix this logic!
    // we can convert both into minutes from midnight?
    // must handle case where end time is day after
    // final hrMin = (endTime.hour - startTime.hour) * 60;
    return 60;
  }
}
