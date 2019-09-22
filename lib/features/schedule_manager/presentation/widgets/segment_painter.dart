import 'package:flutter/material.dart';
import 'dart:math';

import 'package:polysleep/core/utils.dart';
import 'package:polysleep/core/constants.dart' as Constants;
import 'package:polysleep/features/schedule_manager/domain/entities/angle_calculator.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/time.dart';

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

    // var innerStartPoint = Utils.getCoordFromPolar(centerPoint,
    //     radius - segmentWidth, angleCalculator.getStartTimeRadians(), 0);
    // var innerEndPoint = Utils.getCoordFromPolar(centerPoint,
    //     radius - segmentWidth, angleCalculator.getEndTimeRadians(), 0);
    // var outerStartPoint = Utils.getCoordFromPolar(
    //     centerPoint, radius, angleCalculator.getStartTimeRadians(), 0);
    // var outerEndPoint = Utils.getCoordFromPolar(
    //     centerPoint, radius, angleCalculator.getEndTimeRadians(), 0);

    // draw main arc
    var paint = Paint()..color = Colors.red;
    // TODO: add 2pi to sweep angle if start time is day before
    canvas.drawArc(
        Rect.fromCircle(center: centerPoint, radius: radius),
        angleCalculator.getStartAngle(),
        angleCalculator.getSweepAngle(),
        true,
        paint);

    var p = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawArc(
        Rect.fromCircle(center: centerPoint, radius: radius - segmentWidth),
        angleCalculator.getStartAngle(),
        angleCalculator.getSweepAngle(),
        true,
        p);
    drawStartTime(centerPoint, angleCalculator.getStartTimeRadians(), radius,
        segmentWidth, canvas, size);
    drawEndTime(centerPoint, angleCalculator.getEndTimeRadians(), radius,
        segmentWidth, canvas, size);
  }

  void drawStartTime(Offset centerPoint, double startTimeRadians, double radius,
      double segmentWidth, Canvas canvas, Size size) {
    canvas.save();

    // perform rotation of canvas around center
    rotateCanvasAroundCenter(canvas, size, -startTimeRadians);

    TextSpan span = new TextSpan(
        style: new TextStyle(color: Colors.white),
        text: '${this.segment.startTime.hour}');
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(
        canvas,
        new Offset(
            centerPoint.dx + (radius / 1.5), centerPoint.dy - (radius / 10)));

    canvas.restore();
  }

  void drawEndTime(Offset centerPoint, double endTimeRadians, double radius,
      double segmentWidth, Canvas canvas, Size size) {
    canvas.save();

    // perform rotation of canvas around center
    rotateCanvasAroundCenter(canvas, size, -endTimeRadians);

    TextSpan span = new TextSpan(
        style: new TextStyle(color: Colors.white),
        text: '${this.segment.endTime.hour}');
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(
        canvas, new Offset(centerPoint.dx + (radius / 1.5), centerPoint.dy));

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

  void drawInnerBorder(
      Offset centerPoint,
      Offset innerStartPoint,
      Offset innerEndPoint,
      double startTimeRadians,
      double endTimeRadians,
      double segmentWidth,
      double radius,
      Canvas canvas) {
    var borderWidth = 2;
    var borderStartPoint = Utils.getCoordFromPolar(
        centerPoint, radius - segmentWidth + borderWidth, startTimeRadians, 0);
    var borderEndPoint = Utils.getCoordFromPolar(
        centerPoint, radius - segmentWidth + borderWidth, endTimeRadians, 0);
    var path = Path();
    var paint = Paint();
    paint.color = Colors.white;
    path.moveTo(innerStartPoint.dx, innerStartPoint.dy); // start at center
    path.lineTo(borderStartPoint.dx, borderStartPoint.dy); // line across
    path.arcToPoint(borderEndPoint, // outer circle
        radius: Radius.circular(radius),
        clockwise: true);
    path.lineTo(innerEndPoint.dx, innerEndPoint.dy); // back to center

    path.arcToPoint(innerStartPoint,
        radius: Radius.circular(radius), clockwise: false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
