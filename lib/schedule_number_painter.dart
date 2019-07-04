import 'dart:math';

import 'package:flutter/material.dart';

class ClockDialPainter extends CustomPainter{
  final PI = 3.14;
  final clockText;

  final hourTickMarkLength= 10.0;
  final minuteTickMarkLength = 5.0;

  final hourTickMarkWidth= 3.0;
  final minuteTickMarkWidth = 1.5;

  final Paint tickPaint;
  final TextPainter textPainter;
  final TextStyle textStyle;

  final romanNumeralList= [ 'XII','I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X', 'XI'];

  ClockDialPainter({this.clockText= ClockText.arabic})
      :tickPaint= Paint(),
        textPainter= new TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
        textStyle= const TextStyle(
          color: Colors.black,
          fontFamily: 'Times New Roman',
          fontSize: 10.0,
        )
  {
    tickPaint.color= Colors.blueGrey;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var tickMarkLength;
    final angle= 2* PI / 60;
    final radius= size.width/2;
    canvas.save();

    // drawing
    canvas.translate(radius, radius);
    for (var i = 0; i< 60; i++ ) {

      //make the length and stroke of the tick marker longer and thicker depending
      tickMarkLength = i % 5 == 0 ? hourTickMarkLength: minuteTickMarkLength;
      tickPaint.strokeWidth= i % 5 == 0 ? hourTickMarkWidth : minuteTickMarkWidth;
      canvas.drawLine(
          Offset(0.0, -radius), Offset(0.0, -radius+tickMarkLength), tickPaint);


      //draw the text
      if (i%5==0){
        canvas.save();
        canvas.translate(0.0, -radius - 6);

        textPainter.text= TextSpan(
          text: this.clockText==ClockText.roman?
          '${romanNumeralList[i~/5]}'
              :'${i == 0 ? 0 : (i*2)~/5}'
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

    canvas.restore();

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