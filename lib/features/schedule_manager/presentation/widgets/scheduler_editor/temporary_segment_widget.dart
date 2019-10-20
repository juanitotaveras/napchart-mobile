import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polysleep/core/constants.dart';
import 'package:polysleep/core/utils.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_bloc.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_event.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_state.dart';
import 'package:polysleep/features/schedule_manager/presentation/pages/schedule_editor.dart';

const cornerRadius = 10.0;
const corner = Radius.circular(cornerRadius);

class TemporarySegmentWidget extends StatelessWidget {
  final double marginRight;
  final double hourSpacing;

  TemporarySegmentWidget({this.marginRight, this.hourSpacing});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ScheduleEditorBloc>(context);
    return BlocBuilder<ScheduleEditorBloc, ScheduleEditorState>(
        /*condition: (pState, cState) {
      final prevState = Utils.tryCast<SegmentsLoaded>(pState);
      final curState = Utils.tryCast<SegmentsLoaded>(cState);
      if (prevState == null || curState == null) return true;

      return prevState.selectedSegment != curState.selectedSegment;
    }, */
        builder: (BuildContext context, ScheduleEditorState currentState) {
      final state = Utils.tryCast<SegmentsLoaded>(currentState);
      if (state != null && state.selectedSegment != null) {
        final SleepSegment segment = state.selectedSegment;
        final List<Widget> segments = [];
        if (!segment.startAndEndsOnSameDay()) {
          // must create two segments
          final topMarginA = segment.getStartMinutesFromMidnight().toDouble();
          final minutesToMidnight =
              MINUTES_PER_DAY - segment.getStartMinutesFromMidnight();
          final startWidgetList = startSegment(
              context, bloc, minutesToMidnight.toDouble(), topMarginA);
          final endWidgetList = endSegment(context, bloc,
              segment.getEndMinutesFromMidnight().toDouble(), 0.0);
          segments.insertAll(0, startWidgetList);
          segments.insertAll(segments.length, endWidgetList);
        } else {
          final topMargin =
              (hourSpacing * segment.startTime.hour + segment.startTime.minute)
                  .toDouble();
          final wholeWidgetList = wholeWidget(context, bloc,
              segment.getDurationMinutes().toDouble(), topMargin);
          segments.insertAll(0, wholeWidgetList);
          print(segments);
        }

        return Stack(children: segments);
      } else {
        return Container();
      }
    });
  }

  List<Widget> startSegment(BuildContext context, ScheduleEditorBloc bloc,
      double height, double margin) {
    return [
      GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails details) {
            RenderBox box = context.findRenderObject();
            var relativeTapPos = box.globalToLocal(details.globalPosition);
            bloc.dispatch(TemporarySleepSegmentDragged(
                details, relativeTapPos, hourSpacing));
          },
          child: Container(
              key: Key('tempPiece'),
              height: height,
              margin: EdgeInsets.only(right: marginRight, top: margin),
              decoration: BoxDecoration(
                  color: Colors.blue[900].withOpacity(0.5),
                  border: Border.all(width: 3, color: Colors.white),
                  borderRadius: BorderRadius.only(
                      topLeft: corner,
                      topRight: corner,
                      bottomLeft: corner,
                      bottomRight: corner)))),
      renderDragCircleTop(margin, context)
    ];
  }

  List<Widget> endSegment(BuildContext context, ScheduleEditorBloc bloc,
      double height, double margin) {
    return [
      GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails details) {
            RenderBox box = context.findRenderObject();
            var relativeTapPos = box.globalToLocal(details.globalPosition);
            bloc.dispatch(TemporarySleepSegmentDragged(
                details, relativeTapPos, hourSpacing));
          },
          child: Container(
              key: Key('tempPiece'),
              height: height,
              margin: EdgeInsets.only(right: marginRight, top: margin),
              decoration: BoxDecoration(
                  color: Colors.blue[900].withOpacity(0.5),
                  border: Border.all(width: 3, color: Colors.white),
                  borderRadius: BorderRadius.only(
                      topLeft: corner,
                      topRight: corner,
                      bottomLeft: corner,
                      bottomRight: corner)))),
      renderDragCircleBottom(margin, height, context)
    ];
  }

  List<Widget> wholeWidget(BuildContext context, ScheduleEditorBloc bloc,
      double height, double margin) {
    return [
      GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails details) {
            RenderBox box = context.findRenderObject();
            var relativeTapPos = box.globalToLocal(details.globalPosition);
            bloc.dispatch(TemporarySleepSegmentDragged(
                details, relativeTapPos, hourSpacing));
          },
          child: Container(
              key: Key('tempPiece'),
              height: height,
              margin: EdgeInsets.only(right: marginRight, top: margin),
              decoration: BoxDecoration(
                  color: Colors.blue[900].withOpacity(0.5),
                  border: Border.all(width: 3, color: Colors.white),
                  borderRadius: BorderRadius.only(
                      topLeft: corner,
                      topRight: corner,
                      bottomLeft: corner,
                      bottomRight: corner)))),
      renderDragCircleTop(margin, context),
      renderDragCircleBottom(margin, height, context)
    ];
  }

  Widget renderDragCircleTop(double topMargin, BuildContext context) {
    return Positioned(
        top: topMargin - 15,
        right: marginRight + 15,
        child: GestureDetector(
            onVerticalDragUpdate: (DragUpdateDetails details) {
              RenderBox box = context.findRenderObject();
              var relativeTapPos = box.globalToLocal(details.globalPosition);
              BlocProvider.of<ScheduleEditorBloc>(context).dispatch(
                  TemporarySleepSegmentStartTimeDragged(
                      details, relativeTapPos, hourSpacing));
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
              RenderBox box = context.findRenderObject();
              var relativeTapPos = box.globalToLocal(details.globalPosition);
              BlocProvider.of<ScheduleEditorBloc>(context).dispatch(
                  TemporarySleepSegmentEndTimeDragged(
                      details, relativeTapPos, hourSpacing));
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
