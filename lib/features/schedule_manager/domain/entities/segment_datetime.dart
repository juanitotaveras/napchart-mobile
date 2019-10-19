import 'package:meta/meta.dart';

class SegmentDateTime extends DateTime {
  SegmentDateTime({@required int hr, int min, int day})
      : super(2020, 0, day ?? 0, hr, min ?? 0);
}
