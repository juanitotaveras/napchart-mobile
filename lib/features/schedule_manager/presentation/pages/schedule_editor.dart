import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polysleep/core/utils.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_bloc.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_event.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_state.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/scheduler_editor/calendar_grid.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/scheduler_editor/calendar_grid_painter.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/scheduler_editor/edit_segment_bottom_sheet_widget.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/scheduler_editor/loaded_segment_widget.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/scheduler_editor/temporary_segment_widget.dart';

class ScheduleEditor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScheduleEditorState();
}

class _ScheduleEditorState extends State<ScheduleEditor> {
  ScheduleEditorBloc bloc = ScheduleEditorBloc();
  bool initCalled = false;
  @override
  Widget build(BuildContext context) {
    if (!initCalled) {
      bloc.dispatch(LoadSchedule());
      initCalled = true;
    }
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
            builder: (context) => this.bloc,
            child: Center(
                child: Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        renderHeader(),
                        Expanded(
                            child: ListView(children: <Widget>[
                          CalendarGrid(
                              hourSpacing: 60.0,
                              leftLineOffset: Offset(40.0, 0.0)),
                        ])),
                        EditSegmentBottomSheetWidget(),
                      ],
                    )))));
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
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
