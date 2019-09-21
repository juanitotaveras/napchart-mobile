import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class SleepSegment extends Equatable {
  final DateTime startTime;
  final DateTime endTime;
  SleepSegment({@required this.startTime, @required this.endTime})
      : super([startTime, endTime]);
}
