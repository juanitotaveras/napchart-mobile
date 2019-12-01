import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_segment_model.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';

class SleepScheduleModel extends SleepSchedule {
  SleepScheduleModel(
      {@required List<SleepSegmentModel> segments,
      String name = "",
      String difficulty = ""})
      : super(segments: segments, name: name, difficulty: difficulty);

  static String segmentsKey = 'segments';
  static String difficultyKey = 'difficulty';
  static String nameKey = 'name';

  factory SleepScheduleModel.fromJson(Map<String, dynamic> json) {
    final jsonSegments = json[segmentsKey];
    final List<SleepSegment> segments = jsonSegments
        .map<SleepSegmentModel>(
            (jsonSeg) => SleepSegmentModel.fromJson(jsonSeg))
        .toList();
    return SleepScheduleModel(
        name: json[nameKey],
        segments: segments,
        difficulty: json[difficultyKey] ?? 'Easy');
  }
  Map<String, dynamic> toJson() {
    final segmentModels = this.segments.map((seg) => seg as SleepSegmentModel);
    return {
      nameKey: this.name,
      segmentsKey: segmentModels
          .map<Map<String, dynamic>>((seg) => seg.toJson())
          .toList()
    };
  }

  factory SleepScheduleModel.fromEntity(SleepSchedule schedule) {
    return SleepScheduleModel(
        segments: schedule.segments
            .map((seg) => SleepSegmentModel.fromEntity(seg))
            .toList(),
        difficulty: schedule.difficulty,
        name: schedule.name);
  }
}
