import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_bloc.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_event.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_state.dart';

class SleepScheduleCreatorOne extends StatelessWidget {
  renderWidget() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: ListView(children: <Widget>[
          CalendarGrid(hourSpacing: 60.0, leftLineOffset: Offset(40.0, 0.0)),
        ]))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
        body: BlocProvider(
            builder: (context) => ScheduleEditorBloc(),
            child: Center(
                child: Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child:
                        BlocListener<ScheduleEditorBloc, ScheduleEditorState>(
                      listener:
                          (BuildContext context, ScheduleEditorState state) {
                        if (state is TemporarySegmentExists) {
                          // do nothing
                          print('hi state');
                        }
                      },
                      child:
                          BlocBuilder<ScheduleEditorBloc, ScheduleEditorState>(
                        builder:
                            (BuildContext context, ScheduleEditorState state) {
                          return renderWidget();
                        },
                      ),
                    )))));
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
    final ScheduleEditorBloc bloc =
        BlocProvider.of<ScheduleEditorBloc>(context);
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
          if (relativeTapPos.dx >= this.leftLineOffset.dx) {
            bloc.dispatch(
                TemporarySleepSegmentCreated(relativeTapPos, hourSpacing));
          }
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
