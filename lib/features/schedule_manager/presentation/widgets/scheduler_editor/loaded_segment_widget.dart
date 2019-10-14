import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polysleep/core/utils.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_bloc.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_event.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_state.dart';

const cornerRadius = 10.0;
const corner = Radius.circular(cornerRadius);

class LoadedSegmentWidget extends StatelessWidget {
  final double marginRight;
  final double hourSpacing;
  final RenderBox calendarGrid;
  final SleepSegment segment;
  LoadedSegmentWidget(
      {this.marginRight, this.hourSpacing, this.calendarGrid, this.segment});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ScheduleEditorBloc>(context);
    return BlocBuilder<ScheduleEditorBloc, ScheduleEditorState>(
        builder: (BuildContext context, ScheduleEditorState currentState) {
      final state = Utils.tryCast<SegmentsLoaded>(currentState);
      if (state != null) {
        final topMargin =
            (hourSpacing * segment.startTime.hour + segment.startTime.minute)
                .toDouble();
        return Stack(children: [
          GestureDetector(
              // onVerticalDragUpdate: (DragUpdateDetails details) {
              //   bloc.dispatch(TemporarySleepSegmentDragged(
              //       details, calendarGrid, hourSpacing));
              // },
              child: Container(
                  height: segment.getDurationMinutes().toDouble(),
                  margin: EdgeInsets.only(right: marginRight, top: topMargin),
                  decoration: BoxDecoration(
                      color: Colors.blue[900].withOpacity(0.5),
                      border: Border.all(width: 3, color: Colors.white),
                      borderRadius: BorderRadius.only(
                          topLeft: corner,
                          topRight: corner,
                          bottomLeft: corner,
                          bottomRight: corner)))),
          // renderDragCircleTop(topMargin, context),
          // renderDragCircleBottom(
          //     topMargin, segment.getDurationMinutes().toDouble(), context)
        ]);
      } else {
        return Container();
      }
    });
  }

  Widget renderDragCircleTop(double topMargin, BuildContext context) {
    return Positioned(
        top: topMargin - 15,
        right: marginRight + 15,
        child: GestureDetector(
            onVerticalDragUpdate: (DragUpdateDetails details) {
              BlocProvider.of<ScheduleEditorBloc>(context).dispatch(
                  TemporarySleepSegmentStartTimeDragged(
                      details, calendarGrid, hourSpacing));
            },
            child: renderDragCircleGraphic()));
  }

  Widget renderDragCircleBottom(
      double topMargin, double height, BuildContext context) {
    return Positioned(
        top: topMargin + height - 20,
        left: 15,
        child: GestureDetector(
            onVerticalDragUpdate: (DragUpdateDetails details) {
              BlocProvider.of<ScheduleEditorBloc>(context).dispatch(
                  TemporarySleepSegmentEndTimeDragged(
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
          color: Colors.white,
        ),
      ),
      Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
      )
    ]);
  }
}
