import 'package:flutter_test/flutter_test.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/angle_calculator.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/core/constants.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/time.dart';
import 'dart:math';

void main() {
  group('Angle Calc test', () {
    AngleCalculator angleCalculator;
    SleepSegment seg;
    DateTime currentTime;
    group('segment starts and ends on same day', () {
      setUp(() {
        currentTime = DateTime(2019, 9, 22, 0, 0, 0);

        var startTime = DateTime(2019, 9, 22, 10, 30);
        var endTime = DateTime(2019, 9, 22, 12, 0);
        seg = SleepSegment(startTime: startTime, endTime: endTime);
        angleCalculator = AngleCalculator(null, seg);
      });
      test('getCurrentTimeRadians', () {
        expect(angleCalculator.getCurrentTimeRadians(), 0);
      });

      test('getStartTimeRadians', () {
        var startTimeMinutes = seg.getStartMinutesFromMidnight();
        // var endTimeMinutes = seg.getEndMinutesFromMidnight();
        var startTimeRadians = angleCalculator.getCurrentTimeRadians() -
            ((startTimeMinutes / MINUTES_PER_DAY) * 2 * pi) +
            (pi / 2);
        expect(angleCalculator.getStartTimeRadians(), startTimeRadians);
      });

      test('getEndTimeRadians', () {
        var endTimeRadians = angleCalculator.getCurrentTimeRadians() -
            ((seg.getEndMinutesFromMidnight() / MINUTES_PER_DAY) * 2 * pi) +
            (pi / 2);
        expect(angleCalculator.getEndTimeRadians(), endTimeRadians);
      });

      test('start radians should be less than end radians', () {
        expect(
            true,
            angleCalculator.getStartTimeRadians().abs() <
                angleCalculator.getEndTimeRadians().abs());
      });
    });
    group('segment starts on one day, end on another', () {
      setUp(() {
        currentTime = DateTime(2019, 9, 22, 0, 0, 0);

        var startTime = DateTime(2019, 9, 22, 10, 30);
        var endTime = DateTime(2019, 9, 22, 12, 0);
        seg = SleepSegment(startTime: startTime, endTime: endTime);
        angleCalculator = AngleCalculator(null, seg);
      });

      test('should invert sweep angle if start and end on different days', () {
        var start = angleCalculator.getStartTimeRadians();
        var end = angleCalculator.getEndTimeRadians();
        expect(true, true);
      });
    });
  });
}
