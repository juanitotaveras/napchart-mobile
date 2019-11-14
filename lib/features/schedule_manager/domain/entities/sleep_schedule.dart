import 'package:equatable/equatable.dart';
import 'package:polysleep/core/constants.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:meta/meta.dart';

class SleepSchedule extends Equatable {
  final List<SleepSegment> segments;
  final String name;
  final String difficulty;
  SleepSchedule({@required this.segments, this.name = "", this.difficulty = ""})
      : super([segments, name]);

  int get totalSleepMinutes {
    List<int> segMinutes =
        segments.map((seg) => seg.getDurationMinutes()).toList();
    return segMinutes.reduce((segA, segB) => segA + segB);
  }

  int get totalAwakeMinutes => MINUTES_PER_DAY - totalSleepMinutes;

  SleepSegment getSelectedSegment() {
    final List<SleepSegment> selected = segments.where((seg) => seg.isSelected).toList();
    return (selected.length == 0) ? null : selected[0];
  }
}
