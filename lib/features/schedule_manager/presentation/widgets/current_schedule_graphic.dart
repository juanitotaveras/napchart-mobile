import 'package:flutter/material.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/sun_times_painter.dart';
import 'schedule_number_painter.dart';
import 'segment_painter.dart';
import 'dart:math';
import '../../../../core/utils.dart';
import './current_schedule_graphic_styles.dart';

class CurrentScheduleGraphic extends StatelessWidget {
  CurrentScheduleGraphic(
      {Key key, @required this.currentTime, @required this.currentSchedule})
      : super(key: key);
  final DateTime currentTime;
  final SleepSchedule currentSchedule;

  @override
  Widget build(BuildContext context) {
    List<Widget> segmentWidgets = [];
    if (this.currentSchedule != null) {
      var idx = 0;
      this
          .currentSchedule
          .segments
          .forEach((seg) => segmentWidgets.add(Container(
              width: double.infinity,
              height: double.infinity,
              child: CustomPaint(
                painter: SegmentPainter(segment: seg, currentTime: currentTime),
              ))));
    }
    final DateTime _startSun = DateTime(2019, 1, 1, 6);
    final DateTime _endSun = DateTime(2019, 1, 1, 18);
    final sunSegment = SleepSegment(startTime: _startSun, endTime: _endSun);
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Styles.outerBandColor,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0.0, 5.0),
                    blurRadius: 5.0,
                  )
                ],
              ),
            ),
            Container(
                width: double.infinity,
                height: double.infinity,
                child: CustomPaint(
                    painter: SunTimesPainter(sunSegment, currentTime))),
            Container(
              width: double.infinity,
              height: double.infinity,
              child: CustomPaint(
                painter: InnerCirclePainter(context),
              ),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              // padding: const EdgeInsets.all(8.0),
              child: CustomPaint(
                painter: ClockDialPainter(
                    clockText: ClockText.arabic, startTime: this.currentTime),
              ),
            ),
            ...segmentWidgets,
            Container(
                width: double.infinity,
                height: double.infinity,
                child: CustomPaint(painter: InnerCircleFillPainter(context))),
            Container(
                width: double.infinity,
                height: double.infinity,
                child: CustomPaint(
                  painter: ClockHandPainter(),
                ))
          ],
        ));
  }
}

class ClockHandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double radius = min(size.width, size.height) / 2;
    Offset centerPoint = Offset(size.width / 2, size.height / 2);
    var startDist = min(size.width, size.height) / 2.2;
    Offset startPoint =
        Utils.getCoordFromPolar(centerPoint, startDist, pi / 2, 0);
    Offset endPoint =
        Utils.getCoord(centerPoint, startDist + (radius / 6), 0, pi / 2);
    Paint paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 3;
    canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class InnerCircleFillPainter extends CustomPainter {
  BuildContext context;
  InnerCircleFillPainter(this.context);
  @override
  void paint(Canvas canvas, Size size) {
    var radius = min(size.width, size.height) / 2.2 - 2;
    var centerPoint = Offset(size.width / 2, size.height / 2);

    var segmentWidth = radius / 2;
    const strokeWidth = 1;
    canvas.drawCircle(centerPoint, radius - segmentWidth - strokeWidth,
        Paint()..color = Theme.of(context).scaffoldBackgroundColor);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}

class InnerCirclePainter extends CustomPainter {
  BuildContext context;
  InnerCirclePainter(this.context);
  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    Paint inner = Paint()
      ..color = Theme.of(context).scaffoldBackgroundColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;
    Paint outer = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    var radius = min(size.width, size.height) / 2.2;
    canvas.drawCircle(center, radius, inner);
    canvas.drawCircle(center, radius, outer);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
