import 'package:flutter/material.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';

class SleepScheduleCreatorOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    return Container(
//      child: BaseScheduleGraphic()
//    );
    return Scaffold(
        appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            automaticallyImplyLeading: true,
            //`true` if you want Flutter to automatically add Back Button when needed,
            //or `false` if you want to force your own back button every where
            title: Text('Edit schedule'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )),
        //drawer: NavigationDrawer(),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: ListView(children: <Widget>[
                      CalendarGrid(
                        hourSpacing: 60.0,
                        leftLineOffset: Offset(40.0, 0.0),
                      ),
                    ]))
                  ],
                ))));
  }
}

class CalendarGrid extends StatelessWidget {
  CalendarGrid({this.hourSpacing, this.leftLineOffset});
  final double hourSpacing;
  final Offset leftLineOffset;
  @override
  Widget build(BuildContext context) {
    final DateTime _start = DateTime(2019, 1, 1, 22); // y, m d, h, m
    final DateTime _end = DateTime(2019, 1, 2, 6);
    final List<SleepSegment> segments = [
      SleepSegment(startTime: _start, endTime: _end)
    ];
    final List<Widget> segmentWidgets = segments
        .map((seg) => Container(
            width: double.infinity,
            height: 60,
            // color: Colors.red,
            margin: EdgeInsets.fromLTRB(41.0, 0.0, 20.0, 0.0),
            child: GestureDetector(
                onTapUp: (TapUpDetails details) {
                  print('Tap on seg: ${details.globalPosition}');
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                            bottomLeft: const Radius.circular(10.0),
                            bottomRight: const Radius.circular(10.0))),
                    child: CustomPaint(painter: DaySegmentPainter(seg))))))
        .toList();
    return GestureDetector(
        onTapUp: (TapUpDetails details) {
          print('Tap');
          RenderBox box = context.findRenderObject();
          var relativeTapPos = box.globalToLocal(details.globalPosition);
          print('${relativeTapPos}');
          print('${details.globalPosition}');
          print('start time tapped: ${getStartTimeTapped(relativeTapPos)}');
        },
        child: Stack(children: <Widget>[
          Container(
              height: 1440,
              width: double.infinity,
              child: CustomPaint(
                painter: CalendarGridPainter(hourSpacing: this.hourSpacing),
              )),
          ...segmentWidgets,
        ]));
  }

  DateTime getStartTimeTapped(Offset tapPosition) {
    if (tapPosition.dx < this.leftLineOffset.dx) {
      return null;
    }
    // Get new segment
    var hr = tapPosition.dy / this.hourSpacing;
    // now check if we're in the first or second half of that hour
    var part = (hr - (hr.toInt()));
    var min = (part < 0.5) ? 0 : 30;
    return DateTime(2020, 1, 1, hr.toInt(), min);
  }
}

class DaySegmentPainter extends CustomPainter {
  final SleepSegment segment;
  DaySegmentPainter(this.segment);

  @override
  void paint(Canvas canvas, Size size) {
    Paint p = Paint()
      ..color = Colors.red
      ..strokeWidth = 2;
    // var y = 200.0;
    // canvas.drawLine(Offset(0.0, y), Offset(50.0, y), p);
    // print('le size: ${size}');
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class CalendarGridPainter extends CustomPainter {
  CalendarGridPainter({this.hourSpacing});
  final double hourSpacing;
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

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
    // TODO: implement shouldRepaint
    return false;
  }
}
