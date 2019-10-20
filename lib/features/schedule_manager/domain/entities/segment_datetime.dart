import 'package:meta/meta.dart';

class SegmentDateTime extends DateTime {
  SegmentDateTime({@required int hr, int min = 0, int day = 0})
      : super(2020, 0, day, hr, min);
}
