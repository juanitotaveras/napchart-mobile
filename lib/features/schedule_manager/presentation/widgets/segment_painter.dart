import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:polysleep/core/utils.dart';

class SegmentPainter extends CustomPainter {
  final int startTimeMinutes;
  final int endTimeMinutes;
  final double startPointRadians;
  SegmentPainter(
      this.startTimeMinutes, this.endTimeMinutes, this.startPointRadians);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.red;
    // start and end times are in minutes from midnight
    const MINUTES_PER_DAY = 1440;
    // now we must calculate start point, which is from 0 radians
    // (300/1440) = (x/2pi)
    // ( (300*2)/1440 ) = x/pi
    var startTimeRadians =
        startPointRadians - ((startTimeMinutes / MINUTES_PER_DAY) * 2 * pi);
    var endTimeRadians =
        startPointRadians - ((endTimeMinutes / MINUTES_PER_DAY) * 2 * pi);
    var centerPoint = Offset(size.width / 2, size.height / 2);
    var radius = min(size.width, size.height) / 2.2 - 2;

    var segmentWidth = radius / 2;

    var innerStartPoint = Utils.getCoordFromPolar(
        centerPoint, radius - segmentWidth, startTimeRadians, 0);
    var innerEndPoint = Utils.getCoordFromPolar(
        centerPoint, radius - segmentWidth, endTimeRadians, 0);
    var outerStartPoint =
        Utils.getCoordFromPolar(centerPoint, radius, startTimeRadians, 0);
    var outerEndPoint =
        Utils.getCoordFromPolar(centerPoint, radius, endTimeRadians, 0);

    var path = Path();
    path.moveTo(innerStartPoint.dx, innerStartPoint.dy); // start at center
    path.lineTo(outerStartPoint.dx, outerStartPoint.dy); // line across
    path.arcToPoint(outerEndPoint, // outer circle
        radius: Radius.circular(radius),
        clockwise: true);
    path.lineTo(innerEndPoint.dx, innerEndPoint.dy); // back to center

    path.arcToPoint(innerStartPoint,
        radius: Radius.circular(radius), clockwise: false);
    canvas.drawPath(path, paint);

    // draw inner line
    drawInnerLine(centerPoint, innerStartPoint, innerEndPoint, startTimeRadians,
        endTimeRadians, segmentWidth, radius, canvas);
  }

  void drawInnerLine(
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
