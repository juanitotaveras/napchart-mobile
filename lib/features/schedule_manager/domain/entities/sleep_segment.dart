import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class SleepSegment extends Equatable {
  final DateTime startTime;
  final DateTime endTime;

  SleepSegment({@required this.startTime, @required this.endTime})
      : assert(endTime.isAfter(startTime)),
        super([startTime, endTime]);

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
    // one minutes is 60,000 ms
    final ms =
        endTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch;

    return ms ~/ 60000;
  }
}
