import 'package:flutter/material.dart';

class CalendarGridPainter extends CustomPainter {
  CalendarGridPainter({this.hourSpacing});
  final double hourSpacing;
  @override
  void paint(Canvas canvas, Size size) {
    // draw left line
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;
    const marginLeft = 30.0;

    const leftLineOffset = 10;
    canvas.drawLine(Offset(marginLeft + leftLineOffset, 0),
        Offset(marginLeft + leftLineOffset, size.height), paint);

    // draw time and horizontal lines
    var offset = Offset(marginLeft, 0);
    TextPainter textPainter =
        TextPainter(textDirection: TextDirection.ltr, textAlign: TextAlign.end);
    TextStyle textStyle = TextStyle(
        color: Colors.white, fontFamily: 'Times New Roman', fontSize: 12.0);
    for (int i = 0; i < 24; i++) {
      var right = Offset(size.width, offset.dy);
      canvas.drawLine(offset, right, paint);
      textPainter.text = TextSpan(text: '${i}', style: textStyle);
      textPainter.layout();

      var singleDigitOffset = (i < 10) ? 0 : 7;
      var textOffset =
          Offset(offset.dx - 15 - singleDigitOffset, offset.dy - 7);
      if (i > 0) {
        textPainter.paint(canvas, textOffset);
      }
      drawDashedLine(
          canvas, size, Offset(offset.dx, offset.dy + hourSpacing / 2));
      offset = Offset(offset.dx, offset.dy + hourSpacing);
    }
  }

  void drawDashedLine(Canvas canvas, Size size, Offset os) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;
    Offset offset = os;
    var segWidth = 1;
    var space = 4;
    while (offset.dx < size.width) {
      canvas.drawLine(offset, Offset(offset.dx + segWidth, offset.dy), paint);
      offset = Offset(offset.dx + segWidth + space, offset.dy);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
