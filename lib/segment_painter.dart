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
    paint.color = Colors.green;
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
    print("CENTER PT ");
    print(centerPoint);
    var radius = size.width / 2.2 - 0.5;

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
//class DonutPieChart extends StatelessWidget {
//  final List<charts.Series> seriesList;
//  final bool animate;
//
//  DonutPieChart(this.seriesList, {this.animate});
//
//  /// Creates a [PieChart] with sample data and no transition.
//  factory DonutPieChart.withSampleData() {
//    return new DonutPieChart(
//      _createSampleData(),
//      // Disable animations for image tests.
//      animate: false,
//    );
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//    return new charts.PieChart(seriesList,
//        animate: animate,
//        // Configure the width of the pie slices to 60px. The remaining space in
//        // the chart will be left as a hole in the center.
//        defaultRenderer: new charts.ArcRendererConfig(arcWidth: 60));
//  }
//
//  /// Create one series with sample hard coded data.
//  static List<charts.Series<LinearSales, int>> _createSampleData() {
//    final data = [
//      new LinearSales(0, 100),
//      new LinearSales(1, 60),
//      new LinearSales(2, 25),
//      new LinearSales(3, 5),
//    ];
//
//    return [
//      new charts.Series<LinearSales, int>(
//        id: 'Sales',
//        domainFn: (LinearSales sales, _) => sales.year,
//        measureFn: (LinearSales sales, _) => sales.sales,
//        data: data,
//      )
//    ];
//  }
//}
//
///// Sample linear data type.
//class LinearSales {
//  final int year;
//  final int sales;
//
//  LinearSales(this.year, this.sales);
//}