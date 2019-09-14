/// Donut chart example. This is a simple pie chart with a hole in the middle.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'dart:math';


class SegmentPainter extends CustomPainter {
  final int startTime;
  final int endTime;
  final double startPointRadians;
  SegmentPainter(this.startTime, this.endTime, this.startPointRadians);
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    var paint = Paint();
    paint.color = Colors.blue;
    paint.strokeWidth = 5;
    print("start time: " + startTime.toString());
    // start and end times are in minutes from midnight
    const MINUTES_PER_DAY = 1440;
    // now we must calculate start point, which is from 0 radians
    // (300/1440) = (x/2pi)
    // ( (300*2)/1440 ) = x/pi
    var segmentLengthRadians = ((endTime - startTime)/MINUTES_PER_DAY) * 2 * pi;
    // 0.47 radians
    var startTimeRadians = startPointRadians - ((startTime/MINUTES_PER_DAY) * 2 * pi ) ;
    var endTimeRadians = startPointRadians - ((endTime/MINUTES_PER_DAY) * 2 * pi);
    print("startTimeRadians: " + startTimeRadians.toString());
   // tan(segmentLengthRadians) = opposite/adjacent

    // start time:
    // move up an increment
    //const distFromCenter = 0;
    //centerPoint = Offset(centerPoint.dx, centerPoint.dy + distFromCenter);
    var centerPoint = Offset(size.width/2, size.height / 2);
//    print("CENTER PT ");
//    print(centerPoint);
    var radius = min(size.width, size.height) / 2.2 - 4;

    // cornerOne = Offset(centerPoint.)
    var startPoint = Offset(centerPoint.dx + cos(startTimeRadians) * radius,
                          centerPoint.dy - sin(startTimeRadians) * radius);
    var endPoint = Offset(centerPoint.dx + cos(endTimeRadians) * radius,
                        centerPoint.dy - sin(endTimeRadians) * radius);
    //var endOfLine = Offset(centerPoint.dx + 150, centerPoint.dy);
    //canvas.drawLine(centerPoint, endOfLine, paint);
    var path = Path();
    path.moveTo(centerPoint.dx, centerPoint.dy); // start at center
    path.lineTo(startPoint.dx, startPoint.dy); // line across
    path.arcToPoint(Offset(endPoint.dx, endPoint.dy),
        radius: Radius.circular(radius), clockwise: true);
    //path.lineTo(endOfLine.dx, endOfLine.dy - 200); // top of slice
    path.lineTo(centerPoint.dx, centerPoint.dy);

    canvas.drawPath(path, paint);

//    canvas.drawLine(centerPoint, cornerOne, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }

}