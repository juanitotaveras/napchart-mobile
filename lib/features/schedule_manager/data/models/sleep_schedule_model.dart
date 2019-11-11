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

  factory SleepScheduleModel.fromJson(Map<String, dynamic> json) {
    final jsonSegments = json['segments'];
    final List<SleepSegment> segments = jsonSegments
        .map<SleepSegmentModel>(
            (jsonSeg) => SleepSegmentModel.fromJson(jsonSeg))
        .toList();
    return SleepScheduleModel(
        name: json['name'],
        segments: segments,
        difficulty: json['difficulty'] ?? 'Easy');
  }
  Map<String, dynamic> toJson() {
    final segmentModels = this.segments.map((seg) => seg as SleepSegmentModel);
    return {
      'name': this.name,
      'segments': segmentModels
          .map<Map<String, dynamic>>((seg) => seg.toJson())
          .toList()
    };
  }
}
