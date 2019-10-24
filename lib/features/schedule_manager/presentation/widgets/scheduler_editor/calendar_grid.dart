import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polysleep/core/utils.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_bloc.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_event.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_state.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/scheduler_editor/temporary_segment_widget.dart';
import 'package:polysleep/injection_container.dart';

import 'calendar_grid_painter.dart';
import 'loaded_segment_widget.dart';

class CalendarGrid extends StatelessWidget {
  final double hourSpacing;
  final Offset leftLineOffset;
  CalendarGrid({this.hourSpacing, this.leftLineOffset});

  @override
  Widget build(BuildContext context) {
    final ScheduleEditorBloc bloc =
        BlocProvider.of<ScheduleEditorBloc>(context);
    final calendarHeight = 1440.0;
    return StreamBuilder<List<SleepSegment>>(
        stream: bloc.viewModel.loadedSegmentsStream,
        initialData: null,
        builder: (context, snapshot) {
          List<SleepSegment> loadedSegments = snapshot.data;

          List<Widget> loadedSegmentWidgets = [];
          if (loadedSegments != null) {
            loadedSegmentWidgets = loadedSegments
                .where((seg) => !seg.isBeingEdited)
                .toList()
                .asMap()
                .map((index, seg) {
                  return MapEntry(
                      index,
                      Container(
                          height: calendarHeight,
                          width: double.infinity,
                          margin: EdgeInsets.only(left: 41.0),
                          child: LoadedSegmentWidget(
                              marginRight: 10.0,
                              hourSpacing: 60,
                              segment: seg,
                              index: index)));
                })
                .values
                .toList();
          }
          return GestureDetector(
              onTapUp: (TapUpDetails details) {
                RenderBox b = context.findRenderObject();

                var relativeTapPos = b.globalToLocal(details.globalPosition);
                if (relativeTapPos.dx >= this.leftLineOffset.dx) {
                  bloc.dispatch(TemporarySleepSegmentCreated(
                      relativeTapPos, hourSpacing));
                }
              },
              child: Stack(children: <Widget>[
                Container(
                    height: calendarHeight,
                    width: double.infinity,
                    child: CustomPaint(
                      painter:
                          CalendarGridPainter(hourSpacing: this.hourSpacing),
                    )),
                ...loadedSegmentWidgets,
                Container(
                    height: calendarHeight,
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 41.0),
                    child: TemporarySegmentWidget(
                        marginRight: 10.0, hourSpacing: 60))
              ]));
        });
  }
}
