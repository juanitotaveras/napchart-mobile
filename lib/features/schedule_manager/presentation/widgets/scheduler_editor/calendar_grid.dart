import 'package:flutter/material.dart';
import 'package:polysleep/core/utils.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/view_models/schedule_editor_view_model.dart';
import 'package:polysleep/features/schedule_manager/presentation/view_models/view_model_provider.dart';
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
    final ScheduleEditorViewModel bloc =
        ViewModelProvider.of<ScheduleEditorViewModel>(context);
    final calendarHeight = 1440.0;
    return StreamBuilder<SleepSchedule>(
        stream: bloc.loadedScheduleStream,
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          }
          List<SleepSegment> loadedSegments = snapshot.data.segments;

          List<Widget> loadedSegmentWidgets = [];
          if (loadedSegments != null) {
            loadedSegmentWidgets = loadedSegments
                .where((seg) => !seg.isSelected)
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
                  bloc.onTemporarySegmentCreated(relativeTapPos, hourSpacing);
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
