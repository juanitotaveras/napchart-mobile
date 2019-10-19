import 'package:meta/meta.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_segment_model.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';

class SleepScheduleModel extends SleepSchedule {
  SleepScheduleModel({@required List<SleepSegmentModel> segments})
      : super(segments: segments);

  factory SleepScheduleModel.fromJson(Map<String, dynamic> json) {
    final jsonSegments = json['segments'];
    final segments = jsonSegments
        .map((jsonSeg) => SleepSegmentModel.fromJson(jsonSeg))
        .toList();
    return SleepScheduleModel(segments: segments);
  }
  /*
 factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      text: json['text'],
      number: (json['number'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }

  */
}
