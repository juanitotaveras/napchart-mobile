import 'dart:math';

import 'package:flutter/material.dart';
import 'utils.dart';
import 'package:polysleep/src/models/time.dart';

class ClockDialPainter extends CustomPainter{
  final PI = 3.14;
  final clockText;

  var hourTickMarkLength= 10.0;
  var minuteTickMarkLength = 4.0;

  final hourTickMarkWidth= 3.0;
  final minuteTickMarkWidth = 1.5;

  final Paint tickPaint;
  final TextPainter textPainter;
  final TextStyle textStyle;

  final romanNumeralList= [ 'XII','I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X', 'XI'];

  final DateTime startTime;

  ClockDialPainter({this.clockText= ClockText.arabic, this.startTime})
      :tickPaint= Paint(),
        textPainter= new TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
        textStyle= const TextStyle(
          color: Colors.white,
          fontFamily: 'Times New Roman',
          fontSize: 10.0,
        )
  {
    tickPaint.color= Colors.blueGrey;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var tickMarkLength;
    final angle= 2* PI / 24;
    final radius= min(size.width, size.height)/2;
    hourTickMarkLength = radius / 18 ;
    minuteTickMarkLength = radius / 25;
    tickPaint.strokeWidth = 2;
    tickPaint.color = Colors.black;
//        canvas.save();

    // drawing

    var centerPoint = Offset(size.width/2, size.height/2);
    final tickMarkStartRadius = radius - 10;
    final double startTimeRadians = Time.toRadiansFrom(this.startTime) + pi/2;

    for (var i = 0; i < 24; i++) {
      tickMarkLength = i % 6 == 0 ? hourTickMarkLength: minuteTickMarkLength;
      tickPaint.strokeWidth= i % 6 == 0 ? hourTickMarkWidth : minuteTickMarkWidth;
      Offset tickStartPoint = Utils.getCoord(centerPoint, tickMarkStartRadius, i*60, startTimeRadians);
      Offset tickEndPoint = Utils.getCoord(centerPoint, tickMarkStartRadius+tickMarkLength, i*60, startTimeRadians);
      canvas.drawLine(tickStartPoint, tickEndPoint, tickPaint);


      if (i % 6 == 0) {
        textPainter.text= TextSpan(
          text: this.clockText==ClockText.roman?
          '${romanNumeralList[i~/5]}'
              :'${i == 0 ? 0 : i}'
          ,
          style: textStyle,
        );
        textPainter.layout();

        var centerPointForNumPainter = Offset(centerPoint.dx - 3, centerPoint.dy - 5);
        var numberCoord = Utils.getCoord(centerPointForNumPainter,
            /*tickMarkStartRadius+tickMarkLength+5*/ radius,
            i*60, startTimeRadians);
//        print ("num coord: " + numberCoord.toString());
        textPainter.paint(canvas, numberCoord);
      }

    }
    // Given an Offset centerPoint double radius, int minutes,
    // return an x,y of the point on the canvas.
    /*
    canvas.translate(radius, radius);
    for (var i = 0; i< 24; i++ ) {

      //make the length and stroke of the tick marker longer and thicker depending
      tickMarkLength = i % 6 == 0 ? hourTickMarkLength: minuteTickMarkLength;
      tickPaint.strokeWidth= i % 6 == 0 ? hourTickMarkWidth : minuteTickMarkWidth;
      canvas.drawLine(
          Offset(0.0, -radius), Offset(0.0, -radius+tickMarkLength), tickPaint);


      //draw the text
      if (i%6==0){
        canvas.save();
        canvas.translate(0.0, -radius - 6);

        textPainter.text= TextSpan(
          text: this.clockText==ClockText.roman?
          '${romanNumeralList[i~/5]}'
              :'${i == 0 ? 0 : i}'
          ,
          style: textStyle,
        );

        //helps make the text painted vertically
        canvas.rotate(-angle*i);

        textPainter.layout();


        textPainter.paint(canvas, Offset(-(textPainter.width/2), -(textPainter.height/2)));

        canvas.restore();

      }

      canvas.rotate(angle);
    }
*/
    //canvas.restore();

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

enum ClockText{
  roman,
  arabic
}