import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      {this.marginRight, this.hourSpacing, this.segment, this.index});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ScheduleEditorBloc>(context);
    final topMargin =
        (hourSpacing * segment.startTime.hour + segment.startTime.minute)
            .toDouble();
    return Stack(children: [
      GestureDetector(
          onTapUp: (details) {
            bloc.dispatch(LoadedSegmentTapped(this.index));
          },
          child: Container(
              height: segment.getDurationMinutes().toDouble(),
              margin: EdgeInsets.only(right: marginRight, top: topMargin),
              decoration: BoxDecoration(
                  color: Colors.red[900],
                  border: Border.all(width: 3, color: Colors.white),
                  borderRadius: BorderRadius.only(
                      topLeft: corner,
                      topRight: corner,
                      bottomLeft: corner,
                      bottomRight: corner)))),
    ]);
  }
}
