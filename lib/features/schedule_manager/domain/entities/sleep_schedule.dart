import 'package:equatable/equatable.dart';
import 'package:polysleep/core/constants.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
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
    final List<SleepSegment> selected =
        segments.where((seg) => seg.isSelected).toList();
    return (selected.length == 0) ? null : selected[0];
  }

  int getSecondsUntilNextNap(DateTime currentTime) {
    final selectedSegment = getSelectedSegment();
    if (selectedSegment == null) return -1;
    final sdt = SegmentDateTime(hr: currentTime.hour, min: currentTime.minute);
    final cur = DateTime(
        sdt.year, sdt.month, sdt.day, sdt.hour, sdt.minute, currentTime.second);
    final Duration diff = selectedSegment.startTime.difference(cur);

    if (diff.inSeconds > 0) {
      // we have positive amount of minutes until next nap
      return diff.inSeconds;
    } else if (diff.inSeconds < 0 &&
        selectedSegment.endTime.difference(cur).inSeconds > 0) {
      // we are in current nap
      return 0;
    } else if (diff.inSeconds < 0) {
      // nap is next day
      return (MINUTES_PER_DAY * 60) + diff.inSeconds;
    }
    return -1;
  }

  bool hasDifferentSegments(SleepSchedule other) {
    if (this.segments.length != other.segments.length) return true;
    for (int i = 0; i < this.segments.length; i++) {
      if (segments[i] != other.segments[i]) return true;
    }
    return false;
  }

  SleepSchedule clone(
      {List<SleepSegment> segments, String name, String difficulty}) {
    return SleepSchedule(
        segments: segments ?? this.segments,
        name: name ?? this.name,
        difficulty: difficulty ?? this.difficulty);
  }
}
