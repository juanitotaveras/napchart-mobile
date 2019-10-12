import 'package:polysleep/features/schedule_manager/data/models/sleep_segment_model.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tSegmentModel = SleepSegmentModel(
      startTime: SegmentDateTime(h: 1, m: 0),
      endTime: SegmentDateTime(h: 1, m: 5));

  test('should be a subclass of SleepSegment entity', () async {
    //assert
    expect(tSegmentModel, isA<SleepSegment>());
  });
}
