import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polysleep/core/constants.dart';
import 'package:polysleep/core/utils.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_view_model.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/view_model_provider.dart';
import 'package:polysleep/features/schedule_manager/presentation/pages/schedule_editor.dart';
import '../../../../../injection_container.dart';

const cornerRadius = 10.0;
const corner = Radius.circular(cornerRadius);

class TemporarySegmentWidget extends StatelessWidget {
  final double marginRight;
  final double hourSpacing;
  ScheduleEditorViewModel _bloc;
  TemporarySegmentWidget({this.marginRight, this.hourSpacing});

  @override
  Widget build(BuildContext context) {
    _bloc = ViewModelProvider.of<ScheduleEditorViewModel>(context);
    return StreamBuilder<SleepSegment>(
        stream: _bloc.selectedSegmentStream,
        initialData: null,
        builder: (context, snapshot) {
          final s = snapshot.data ?? _bloc.selectedSegment;
          if (s == null) {
            return Container();
          }
          final SleepSegment segment = s;
          final List<Widget> segments = [];
          if (!segment.startAndEndsOnSameDay()) {
            // must create two segments
            final topMarginA = segment.getStartMinutesFromMidnight().toDouble();
            final minutesToMidnight =
                MINUTES_PER_DAY - segment.getStartMinutesFromMidnight();
            final startWidgetList = startSegment(
                context, _bloc, minutesToMidnight.toDouble(), topMarginA);
            final endWidgetList = endSegment(context, _bloc,
                segment.getEndMinutesFromMidnight().toDouble(), 0.0);
            segments.insertAll(0, startWidgetList);
            segments.insertAll(segments.length, endWidgetList);
          } else {
            final topMargin = (hourSpacing * segment.startTime.hour +
                    segment.startTime.minute)
                .toDouble();
            final wholeWidgetList = wholeWidget(context, _bloc,
                segment.getDurationMinutes().toDouble(), topMargin);
            segments.insertAll(0, wholeWidgetList);
          }
          return Stack(children: segments);
        });
  }

  List<Widget> startSegment(BuildContext context, ScheduleEditorViewModel bloc,
      double height, double margin) {
    return [
      GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails details) {
            bloc.onSelectedSleepSegmentDragged(
                details.localPosition, hourSpacing);
          },
          onVerticalDragEnd: (DragEndDetails details) {
            bloc.onSelectedSleepSegmentEndDrag();
          },
          onVerticalDragStart: (DragStartDetails details) {
            RenderBox box = context.findRenderObject();
            var relativeTapPos = box.globalToLocal(details.globalPosition);

            bloc.onSelectedSegmentStartDrag(relativeTapPos, hourSpacing);
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

  List<Widget> endSegment(BuildContext context, ScheduleEditorViewModel bloc,
      double height, double margin) {
    return [
      GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails details) {
            RenderBox box = context.findRenderObject();
            var relativeTapPos = box.globalToLocal(details.globalPosition);
            bloc.onSelectedSleepSegmentDragged(relativeTapPos, hourSpacing);
          },
          onVerticalDragEnd: (DragEndDetails details) {
            bloc.onSelectedSleepSegmentEndDrag();
          },
          onVerticalDragStart: (DragStartDetails details) {
            RenderBox box = context.findRenderObject();
            var relativeTapPos = box.globalToLocal(details.globalPosition);
            bloc.onSelectedSegmentEndSectionStartDrag(
                relativeTapPos, hourSpacing);
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

  List<Widget> wholeWidget(BuildContext context, ScheduleEditorViewModel bloc,
      double height, double margin) {
    return [
      GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails details) {
            RenderBox box = context.findRenderObject();
            var relativeTapPos = box.globalToLocal(details.globalPosition);

            bloc.onSelectedSleepSegmentDragged(relativeTapPos, hourSpacing);
          },
          onVerticalDragEnd: (DragEndDetails details) {
            bloc.onSelectedSleepSegmentEndDrag();
          },
          onVerticalDragStart: (DragStartDetails details) {
            RenderBox box = context.findRenderObject();
            var relativeTapPos = box.globalToLocal(details.globalPosition);

            bloc.onSelectedSegmentStartDrag(relativeTapPos, hourSpacing);
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
              ViewModelProvider.of<ScheduleEditorViewModel>(context)
                  .onSelectedSegmentStartTimeDragged(
                      relativeTapPos, hourSpacing);
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
              ViewModelProvider.of<ScheduleEditorViewModel>(context)
                  .onSelectedSegmentEndTimeDragged(relativeTapPos, hourSpacing);
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
