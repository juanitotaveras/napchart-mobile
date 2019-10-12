import 'package:flutter/material.dart';
import 'package:polysleep/core/presentation/angle_calculator.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sun_segment.dart';
import 'dart:math';

class SunTimesPainter extends CustomPainter {
  final SleepSegment segment;
  final DateTime currentTime;
  SunTimesPainter(this.segment, this.currentTime);
  @override
  void paint(Canvas canvas, Size size) {
    var angleCalculator = AngleCalculator(null, segment);

    var centerPoint = Offset(size.width / 2, size.height / 2);
    var radius = min(size.width, size.height) / 2.01;

    var paint = Paint()..color = Colors.yellow;
    canvas.drawArc(
        Rect.fromCircle(center: centerPoint, radius: radius),
        angleCalculator.getStartAngle(),
        angleCalculator.getSweepAngle(),
        true,
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
