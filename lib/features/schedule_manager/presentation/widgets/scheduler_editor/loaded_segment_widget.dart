import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polysleep/core/constants.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_bloc.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_event.dart';

const cornerRadius = 10.0;
const corner = Radius.circular(cornerRadius);

class LoadedSegmentWidget extends StatelessWidget {
  final double marginRight;
  final double hourSpacing;
  final SleepSegment segment;
  final int index;
  LoadedSegmentWidget(
      {Key key, this.marginRight, this.hourSpacing, this.segment, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ScheduleEditorBloc>(context);
    final List<Widget> segments = [];
    if (!segment.startAndEndsOnSameDay()) {
      // must create two segments
      final topMarginA = segment.getStartMinutesFromMidnight().toDouble();
      final minutesToMidnight =
          MINUTES_PER_DAY - segment.getStartMinutesFromMidnight();
      segments.add(startSegment(
          context, bloc, minutesToMidnight.toDouble(), topMarginA));
      segments.add(endSegment(
          context, bloc, segment.getEndMinutesFromMidnight().toDouble(), 0.0));
    } else {
      final topMargin =
          (hourSpacing * segment.startTime.hour + segment.startTime.minute)
              .toDouble();
      segments.add(wholeWidget(
          context, bloc, segment.getDurationMinutes().toDouble(), topMargin));
    }

    return Stack(children: segments);
  }

  Widget startSegment(BuildContext context, ScheduleEditorBloc bloc,
      double height, double margin) {
    final borderSide = BorderSide(color: Colors.white, width: 3);

    return GestureDetector(
        onTapUp: (details) {
          bloc.dispatch(LoadedSegmentTapped(this.index));
        },
        child: Container(
            key: Key('piece'),
            height: height,
            margin: EdgeInsets.only(right: marginRight, top: margin),
            decoration: BoxDecoration(
                color: Colors.red[900],
                border: Border.all(width: 2, color: Colors.white),
                borderRadius:
                    BorderRadius.only(topLeft: corner, topRight: corner))));
  }

  Widget endSegment(BuildContext context, ScheduleEditorBloc bloc,
      double height, double margin) {
    return GestureDetector(
        onTapUp: (details) {
          bloc.dispatch(LoadedSegmentTapped(this.index));
        },
        child: Container(
            key: Key('piece'),
            height: height,
            margin: EdgeInsets.only(right: marginRight, top: margin),
            decoration: BoxDecoration(
                color: Colors.red[900],
                border: Border.all(width: 2, color: Colors.white),
                borderRadius: BorderRadius.only(
                    bottomLeft: corner, bottomRight: corner))));
  }

  Widget wholeWidget(BuildContext context, ScheduleEditorBloc bloc,
      double height, double margin) {
    return GestureDetector(
        onTapUp: (details) {
          bloc.dispatch(LoadedSegmentTapped(this.index));
        },
        child: Container(
            key: Key('piece'),
            height: height,
            margin: EdgeInsets.only(right: marginRight, top: margin),
            decoration: BoxDecoration(
                color: Colors.red[900],
                border: Border.all(width: 2, color: Colors.white),
                borderRadius: BorderRadius.only(
                    topLeft: corner,
                    topRight: corner,
                    bottomLeft: corner,
                    bottomRight: corner))));
  }
}
