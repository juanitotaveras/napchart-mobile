import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polysleep/core/utils.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_view_model.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/view_model_provider.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/scheduler_editor/calendar_grid.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/scheduler_editor/calendar_grid_painter.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/scheduler_editor/edit_segment_bottom_sheet_widget.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/scheduler_editor/loaded_segment_widget.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/scheduler_editor/schedule_editor_header.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/scheduler_editor/temporary_segment_widget.dart';
import '../../../../injection_container.dart';

class ScheduleEditor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScheduleEditorState();
}

class _ScheduleEditorState extends State<ScheduleEditor> {
  ScheduleEditorViewModel bloc = sl<ScheduleEditorViewModel>();
  bool initCalled = false;
  @override
  Widget build(BuildContext context) {
    if (!initCalled) {
      bloc.onLoadSchedule();
      initCalled = true;
    }
    return StreamBuilder<bool>(
        stream: this.bloc.unsavedChangesExistStream,
        initialData: false,
        builder: (context, unsavedChangesExistStream) {
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
                      onPressed: () {
                        Navigator.pop(context, 'test function');
                      }),
                  actions: actionsList(unsavedChangesExistStream.data)),
              //drawer: NavigationDrawer(),

              body: ViewModelProvider(
                  bloc: this.bloc,
                  child: Center(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // renderHeader(),
                              ScheduleEditorHeader(),
                              Expanded(
                                  child: ListView(children: <Widget>[
                                CalendarGrid(
                                    hourSpacing: 60.0,
                                    leftLineOffset: Offset(40.0, 0.0)),
                              ])),
                              EditSegmentBottomSheetWidget(),
                            ],
                          )))));
        });
  }

  List<Widget> actionsList(bool unsavedChangesExist) {
    return unsavedChangesExist ? [saveButton()] : [];
  }

  Widget saveButton() {
    return FlatButton(
      textColor: Colors.white,
      onPressed: () {
        bloc.onSaveChangesPressed();
      },
      child: Text("SAVE"),
      shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
    );
  }

  @override
  void dispose() {
    // bloc.dispose();
    super.dispose();
  }
}
