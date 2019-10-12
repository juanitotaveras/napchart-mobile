import 'package:flutter/material.dart';
import 'package:polysleep/core/presentation/angle_calculator.dart';
import 'dart:math';

import 'package:polysleep/core/utils.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import './segment_painter_styles.dart';
import '../time_formatter.dart';

class SegmentPainter extends CustomPainter {
  final SleepSegment segment;
  final DateTime currentTime;
  SegmentPainter(this.segment, this.currentTime);
  @override
  void paint(Canvas canvas, Size size) {
    var angleCalculator = AngleCalculator(currentTime, segment);

    var centerPoint = Offset(size.width / 2, size.height / 2);
    var radius = min(size.width, size.height) / 2.2 - 2;
    var segmentWidth = radius / 2;

    var paint = Paint()..color = Colors.red;
    canvas.drawArc(
        Rect.fromCircle(center: centerPoint, radius: radius),
        angleCalculator.getStartAngle(),
        angleCalculator.getSweepAngle(),
        true,
        paint);

    var p = Paint()
      ..color = Styles.innerLineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawArc(
        Rect.fromCircle(center: centerPoint, radius: radius - segmentWidth),
        angleCalculator.getStartAngle(),
        angleCalculator.getSweepAngle(),
        true,
        p);
    drawStartTime(centerPoint, radius, canvas, size, angleCalculator);
    drawEndTime(centerPoint, radius, canvas, size, angleCalculator);
  }

  void drawStartTime(Offset centerPoint, double radius, Canvas canvas,
      Size size, AngleCalculator angleCalculator) {
    canvas.save();

    rotateCanvasAroundCenter(canvas, size, angleCalculator.getStartTextAngle());

    TimeFormatter tf = TimeFormatter(this.segment.startTime);
    TextSpan span = new TextSpan(
        style: new TextStyle(color: Colors.white),
        text: '${tf.getMilitaryTime()}');
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, angleCalculator.getStartTextOffset(centerPoint, radius));
    canvas.restore();
  }

  void drawEndTime(Offset centerPoint, double radius, Canvas canvas, Size size,
      AngleCalculator angleCalculator) {
    canvas.save();

    // perform rotation of canvas around center
    rotateCanvasAroundCenter(canvas, size, angleCalculator.getEndTextAngle());

    TimeFormatter tf = TimeFormatter(this.segment.endTime);
    TextSpan span = new TextSpan(
        style: new TextStyle(color: Colors.white),
        text: '${tf.getMilitaryTime()}');
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, angleCalculator.getEndTextOffset(centerPoint, radius));

    canvas.restore();
  }

  void rotateCanvasAroundCenter(Canvas canvas, Size size, double angle) {
    var image = size;
    final double r =
        sqrt(image.width * image.width + image.height * image.height) / 2;
    final alpha = atan(image.height / image.width);
    final beta = alpha + angle;
    final shiftY = r * sin(beta);
    final shiftX = r * cos(beta);
    final translateX = image.width / 2 - shiftX;
    final translateY = image.height / 2 - shiftY;
    canvas.translate(translateX, translateY);
    canvas.rotate(angle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
