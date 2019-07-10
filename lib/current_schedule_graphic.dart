import 'package:flutter/material.dart';
import 'time.dart';
import 'schedule_number_painter.dart';
import 'segment_painter.dart';
import 'dart:math';

class CurrentScheduleGraphic extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CurrentScheduleGraphicState();
  }
}

class _CurrentScheduleGraphicState extends State<CurrentScheduleGraphic> {
  Time currentTime = Time.fromDateTime(DateTime.now());

  void changeCurrentTime() {
    setState(() {
      currentTime = Time.fromDateTime(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("curentTime: ");
    print(currentTime);
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: CustomPaint(
            painter: ClockDialPainter(clockText: ClockText.arabic),
          ),
        ),
        Container(
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(
                painter: SegmentPainter(1320, 90,
                    Time.fromDateTime(DateTime.now()).toRadians() + pi/2) // 10pm to 1:30am
            )
        ),
      ],
    );
  }

}