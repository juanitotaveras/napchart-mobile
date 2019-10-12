import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_bloc.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_event.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_state.dart';

class TemporarySegmentWidget extends StatelessWidget {
  final double marginLeft;
  final double marginRight;
  final double hourSpacing;
  final RenderBox calendarGrid;
  static const verticalPadding = 10.0;
  static const cornerRadius = 10.0;
  static const corner = Radius.circular(cornerRadius);

  TemporarySegmentWidget(
      {this.marginLeft, this.marginRight, this.hourSpacing, this.calendarGrid});
  ScheduleEditorBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<ScheduleEditorBloc>(context);
    // TODO: Create an enclosing container that will have a
    // stack of the elements
    return BlocBuilder<ScheduleEditorBloc, ScheduleEditorState>(
        builder: (BuildContext context, ScheduleEditorState state) {
      if (state is TemporarySegmentExists) {
        final segment = state.segment;
        // final double padding = 10;
        final topMargin =
            (hourSpacing * segment.startTime.hour + segment.startTime.minute)
                .toDouble();
        return renderContainerWithRoundedBorders(topMargin, state.segment);
        // return Container(
        // width: double.infinity,
        // height:
        //     segment.getDurationMinutes().toDouble() + (verticalPadding * 2),
        // margin: EdgeInsets.only(
        //     top: topMargin - verticalPadding,
        //     left: marginLeft,
        //     right: marginRight),
        // padding:
        //     EdgeInsets.only(top: verticalPadding, bottom: verticalPadding),
        // // color: Colors.red,
        // // padding: EdgeInsets.fromLTRB(0.0, padding, 0.0, padding),

        // child: renderContainerWithRoundedBorders(topMargin, state.segment));
      } else {
        return Container();
      }
    });
  }

  Widget renderContainerWithRoundedBorders(
      double topMargin, SleepSegment segment) {
    return Stack(children: [
      GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails details) {
            // SleepSegment newSegment = SleepSegment(
            //     startTime:
            //         segment.startTime.subtract(Duration(minutes: 15)));
            // print('le drag: $details');
            bloc.dispatch(TemporarySleepSegmentDragged(
                details, calendarGrid, hourSpacing));
          },
          child: Container(
              width: double.infinity,
              height: segment.getDurationMinutes().toDouble(),
              // padding: EdgeInsets.only(
              //     top: verticalPadding, bottom: verticalPadding),
              margin: EdgeInsets.only(
                  top: topMargin, left: marginLeft, right: marginRight),
              // margin:
              //     EdgeInsets.fromLTRB(marginLeft, topMargin, marginRight, 0.0),
              decoration: BoxDecoration(
                  color: Colors.blue[900],
                  border: Border.all(width: 3, color: Colors.yellow[100]),
                  borderRadius: BorderRadius.only(
                      topLeft: corner,
                      topRight: corner,
                      bottomLeft: corner,
                      bottomRight: corner)))),
      renderDragCircleTop(topMargin),
      renderDragCircleBottom(topMargin, segment.getDurationMinutes().toDouble())
    ]);
  }

  Widget renderDragCircleTop(double topMargin) {
    return Positioned(
        top: topMargin - 15,
        right: marginRight + 15,
        child: GestureDetector(
            onTapUp: (TapUpDetails details) {
              print('Tap on drag circle!: ${details.globalPosition}');
            },
            onVerticalDragUpdate: (DragUpdateDetails details) {
              print('DRAG UPDATE FOR TOP: ${details}');
              // print(bloc);
              bloc.dispatch(TemporarySleepSegmentStartTimeDragged(
                  details, calendarGrid, hourSpacing));
            },
            child: renderDragCircleGraphic()));
  }

  Widget renderDragCircleBottom(double topMargin, double height) {
    return Positioned(
        bottom: 0,
        left: marginLeft + 15,
        child: GestureDetector(
            onTapUp: (TapUpDetails details) {
              print('Tap on drag circle!: ${details.globalPosition}');
            },
            onVerticalDragUpdate: (DragUpdateDetails details) {
              // print('DRAG UPDATE FOR BOTTOM: ${details}');
              // print(bloc);
              bloc.dispatch(TemporarySleepSegmentEndTimeDragged(
                  details, calendarGrid, hourSpacing));
            },
            child: renderDragCircleGraphic()));
  }

  Widget renderDragCircleGraphic() {
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.yellow[100],
        ),
      ),
      Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue[400],
        ),
      )
    ]);
  }
}
