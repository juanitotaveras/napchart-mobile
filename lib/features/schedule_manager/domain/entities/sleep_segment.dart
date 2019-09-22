import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class SleepSegment extends Equatable {
  final DateTime startTime;
  final DateTime endTime;
  SleepSegment({@required this.startTime, @required this.endTime})
      : super([startTime, endTime]);

  int getStartMinutesFromMidnight() {
    return startTime.hour * 60 + startTime.minute;
  }

  int getEndMinutesFromMidnight() {
    return endTime.hour * 60 + endTime.minute;
  }

  bool startAndEndsOnSameDay() {
    return startTime.day == endTime.day;
  }
}
