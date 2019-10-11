import 'package:meta/meta.dart';

import '../../domain/entities/sleep_segment.dart';

class SleepSegmentModel extends SleepSegment {
  SleepSegmentModel({@required DateTime startTime, @required DateTime endTime})
      : super(startTime: startTime, endTime: endTime);
}
