import 'package:meta/meta.dart';

class SegmentDateTime extends DateTime {
  SegmentDateTime({@required int hr, @required int min, int day})
      : super(2020, 0, (day == null) ? 0 : day, hr, min);
}
