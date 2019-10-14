import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_bloc.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_event.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_state.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/scheduler_editor/calendar_grid_painter.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/scheduler_editor/edit_segment_bottom_sheet_widget.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/scheduler_editor/loaded_segment_widget.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/scheduler_editor/temporary_segment_widget.dart';

class ScheduleEditor extends StatelessWidget {
  renderWidget(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        renderHeader(),
        Expanded(
            child: ListView(children: <Widget>[
          CalendarGrid(hourSpacing: 60.0, leftLineOffset: Offset(40.0, 0.0)),
        ])),
        EditSegmentBottomSheetWidget(),
      ],
    );
  }

  Widget renderHeader() {
    return Container(
      height: 60,
      width: double.infinity,
      padding: EdgeInsets.only(left: 30, right: 30),
      color: Colors.blueGrey,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(-1.0, 0.0),
            child: Text(
              'Choose schedule',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Align(
              alignment: Alignment(1.0, -0.5),
              child: Text(
                'Sleep: x hrs',
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Align(
              alignment: Alignment(1.0, 0.5),
              child: Text('Awake: x hrs',
                  textAlign: TextAlign.end,
                  style: TextStyle(fontWeight: FontWeight.bold)))
        ],
      ),
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
                        if (state is TemporarySegmentCreated) {
                          // do nothing
                          print('hi state');
                          // showModalBottomSheet(
                          //     context: context,
                          //     builder: (context) {
                          //       return Container(
                          //           height: 100,
                          //           child: Column(
                          //             children: <Widget>[
                          //               ListTile(title: Text('SOME STUFF'))
                          //             ],
                          //           ));
                          //     });
                        }
                      },
                      child:
                          BlocBuilder<ScheduleEditorBloc, ScheduleEditorState>(
                        builder:
                            (BuildContext context, ScheduleEditorState state) {
                          // if (state is TemporarySegmentExists) {
                          //   return renderWidget(state.segment);
                          // } else {
                          //   return renderWidget(null);
                          // }
                          return renderWidget(context);
                        },
                      ),
                    )))));
  }
}

class CalendarGrid extends StatelessWidget {
  final double hourSpacing;
  final Offset leftLineOffset;
  CalendarGrid({this.hourSpacing, this.leftLineOffset});

  @override
  Widget build(BuildContext context) {
    final ScheduleEditorBloc bloc =
        BlocProvider.of<ScheduleEditorBloc>(context);
    RenderBox box = context.findRenderObject();
    final calendarHeight = 1440.0;
    print('look at le bloc: ${bloc}');
    // TODO: Add more segments to the stack
    return BlocBuilder<ScheduleEditorBloc, ScheduleEditorState>(
      builder: (BuildContext context, ScheduleEditorState state) {
        List<SleepSegment> loadedSegments = null;
        if (state is TemporarySegmentCreated) {
          loadedSegments = state.loadedSegments;
        } else if (state is SelectedSegmentChanged) {
          loadedSegments = state.loadedSegments;
        } else if (state is SegmentsLoaded) {
          loadedSegments = state.loadedSegments;
        }

        List<Widget> loadedSegmentWidgets = [];
        if (loadedSegments != null) {
          loadedSegmentWidgets = loadedSegments.map((seg) {
            return Container(
                height: calendarHeight,
                width: double.infinity,
                margin: EdgeInsets.only(left: 41.0),
                child: LoadedSegmentWidget(
                    marginRight: 10.0,
                    hourSpacing: 60,
                    calendarGrid: box,
                    segment: seg));
          }).toList();
        }
        print('loaded: $loadedSegments');
        return GestureDetector(
            onTapUp: (TapUpDetails details) {
              RenderBox b = context.findRenderObject();

              var relativeTapPos = b.globalToLocal(details.globalPosition);
              if (relativeTapPos.dx >= this.leftLineOffset.dx) {
                bloc.dispatch(
                    TemporarySleepSegmentCreated(relativeTapPos, hourSpacing));
              }
            },
            child: Stack(children: <Widget>[
              Container(
                  height: calendarHeight,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: CalendarGridPainter(hourSpacing: this.hourSpacing),
                  )),
              ...loadedSegmentWidgets,
              Container(
                  height: calendarHeight,
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 41.0),
                  child: TemporarySegmentWidget(
                      marginRight: 10.0, hourSpacing: 60, calendarGrid: box))
            ]));
      },
    );
  }
}
