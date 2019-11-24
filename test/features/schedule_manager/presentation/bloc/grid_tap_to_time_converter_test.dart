import 'package:flutter_test/flutter_test.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/presentation/view_models/schedule_editor_view_model.dart';

void main() {
  group('grid tap', () {
    test('should yield correct datetime for tap on hour', () {
      final pos = Offset(30.0, 60.0);
      final spacing = 60.0;
      final granularity = 30;
      DateTime d =
          GridTapToTimeConverter.touchInputToTime(pos, spacing, granularity);

      expect(d, equals(SegmentDateTime(hr: 1, min: 0)));
    });

    test('should yield correct datetime for tap on mid-hour', () {
      final pos = Offset(30.0, 90.0);
      final spacing = 60.0;
      final granularity = 30;
      DateTime d =
          GridTapToTimeConverter.touchInputToTime(pos, spacing, granularity);

      expect(d, equals(SegmentDateTime(hr: 1, min: 30)));
    });
  });
}
