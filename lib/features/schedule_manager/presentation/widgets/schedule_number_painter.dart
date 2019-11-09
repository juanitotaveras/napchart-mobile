import 'dart:math';

import 'package:flutter/material.dart';
import '../../../../core/utils.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/time.dart';

class ClockDialPainter extends CustomPainter {
  final PI = 3.14;
  final clockText;

  var hourTickMarkLength = 10.0;
  var minuteTickMarkLength = 4.0;

  final hourTickMarkWidth = 3.0;
  final minuteTickMarkWidth = 1.5;

  final Paint tickPaint;
  final TextPainter textPainter;
  final TextStyle textStyle;

  final DateTime startTime;

  ClockDialPainter({this.clockText = ClockText.arabic, this.startTime})
      : tickPaint = Paint(),
        textPainter = new TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
        textStyle = const TextStyle(
          color: Colors.white,
          fontFamily: 'Roboto',
          fontSize: 12.0,
        ) {
    tickPaint.color = Colors.blueGrey;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var tickMarkLength;
    final angle = 2 * PI / 24;
    final radius = min(size.width, size.height) / 2;
    hourTickMarkLength = radius / 15;
    minuteTickMarkLength = radius / 30;
    tickPaint.strokeWidth = 2;
    tickPaint.color = Colors.black;
//        canvas.save();

    // drawing

    var centerPoint = Offset(size.width / 2, size.height / 2);
    final tickMarkStartRadius = radius / 1.1;
    final double startTimeRadians = Time.toRadiansFrom(this.startTime) + pi / 2;

    for (var i = 0; i < 24; i++) {
      tickMarkLength = i % 6 == 0 ? hourTickMarkLength : minuteTickMarkLength;
      tickPaint.strokeWidth =
          i % 6 == 0 ? hourTickMarkWidth : minuteTickMarkWidth;
      Offset tickStartPoint = Utils.getCoord(
          centerPoint, tickMarkStartRadius, i * 60, startTimeRadians);
      Offset tickEndPoint = Utils.getCoord(centerPoint,
          tickMarkStartRadius + tickMarkLength, i * 60, startTimeRadians);
      canvas.drawLine(tickStartPoint, tickEndPoint, tickPaint);

      if (i % 6 == 0) {
        textPainter.text = TextSpan(
          text: '${i == 0 ? 0 : i}',
          style: textStyle,
        );
        textPainter.layout();

        var centerPointForNumPainter =
            Offset(centerPoint.dx - 3, centerPoint.dy - 5);
        var numberCoord = Utils.getCoord(
            centerPointForNumPainter,
            /*tickMarkStartRadius+tickMarkLength+5*/ radius * 1.01,
            i * 60,
            startTimeRadians);
        textPainter.paint(canvas, numberCoord);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

enum ClockText { roman, arabic }
