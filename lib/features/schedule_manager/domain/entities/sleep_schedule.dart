import 'package:equatable/equatable.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:meta/meta.dart';

class SleepSchedule extends Equatable {
  final List<SleepSegment> segments;
  SleepSchedule({@required this.segments}) : super([segments]);
}
