import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polysleep/core/utils.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_bloc.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_event.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_state.dart';
import 'package:intl/intl.dart';

abstract class EditBottomSheetView {
  String getStartTime();
  String getEndTime();
}

class ViewModel {
  String startTime;
  String endTime;
}

class EditSegmentBottomSheetPresenter extends EditBottomSheetView {
  // wait... view model should not know about presenter.
  // who instantiates presenter??????

  // Actually, this is not correct

  final SegmentsLoaded state;
  final ViewModel vm = ViewModel();
  EditSegmentBottomSheetPresenter(this.state) {
    vm.startTime = formatter.format(state.selectedSegment.startTime);
    vm.endTime = formatter.format(state.selectedSegment.endTime);
  }

  final DateFormat formatter = DateFormat('Hm');
  @override
  String getStartTime() {
    return vm.startTime;
  }

  @override
  String getEndTime() {
    return vm.endTime;
  }
}

class EditSegmentBottomSheetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ScheduleEditorBloc>(context);

    const cornerRadius = 5.0;
    const corner = Radius.circular(cornerRadius);

    // TODO: Implement a 'should update' function
    //     using prevState, curState

    // Widget must have a "presenter" which formats time, selects language, etc
    // OR we can do this in the Bloc, and the "state" will actually have the
    // "state" of the UI
    /*
    Widget should be grabbing values from a ViewModel, which 
    is populated by the Presenter.

    ViewModel can be instantiated in the build() method.
    Should ViewModel have a reference


    ViewModel implements View 'interface', so we know what methods are available.



    Summary:
    ViewModel should be instantiated in the "build method". 
    Widget does not know about Presenter.
    But ViewModel must instantiate presenter
    ViewModel should also implement a View abstract class,
    So that widget knows what is available.

    // ViewModel is going to need our current state,
    so that the Presenter knows what to put inside
    */
    return BlocBuilder<ScheduleEditorBloc, ScheduleEditorState>(
        condition: (prevState, curState) {
      final pState = Utils.tryCast<SegmentsLoaded>(prevState);
      final cState = Utils.tryCast<SegmentsLoaded>(curState);
      if (pState == null || cState == null) return true;

      return pState.selectedSegment != cState.selectedSegment;
    }, builder: (BuildContext context, ScheduleEditorState currentState) {
      final state = Utils.tryCast<SegmentsLoaded>(currentState);
      if (state != null && state.selectedSegment != null) {
        final presenter = EditSegmentBottomSheetPresenter(state);
        final SleepSegment segment = state.selectedSegment;

        return Container(
            height: 130,
            // color: Colors.blue,
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius:
                    BorderRadius.only(topLeft: corner, topRight: corner)),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.cancel,
                          size: 30.0,
                        ),
                        onPressed: () {
                          print('cancel pressed ya\'ll');
                          bloc.dispatch(SelectedSegmentCancelled());
                        }),
                    Expanded(
                        flex: 1,
                        child: Text('',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16.0, fontFamily: 'Roboto'))),
                    Container(alignment: Alignment.centerRight, width: 30.0)
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: Container()),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Start time',
                            style: TextStyle(
                                fontSize: 14.0, fontFamily: 'Roboto')),
                        Text(presenter.getStartTime()),
                      ],
                    ),
                    Expanded(child: Container()),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('End time', style: TextStyle(fontSize: 14.0)),
                        Text(presenter.getEndTime())
                      ],
                    ),
                    Expanded(child: Container()),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Duration'),
                        Text(
                          '${segment.getDurationMinutes()}',
                          // textAlign: TextAlign.left,
                        )
                      ],
                    ),
                    Expanded(child: Container())
                  ],
                ),
                SizedBox(height: 0),
                Row(
                  children: <Widget>[
                    // SizedBox(width: 10),
                    // RaisedButton(
                    //   onPressed: () {
                    //     print('delete pressed');
                    //   },
                    //   child: Text('Delete', style: TextStyle(fontSize: 20)),
                    // ),
                    Expanded(flex: 100, child: Container()),
                    FlatButton(
                      onPressed: () {
                        bloc.dispatch(SelectedSegmentSaved());
                      },
                      child: Text('SAVE',
                          style: TextStyle(fontSize: 20, color: Colors.red)),
                    ),
                    SizedBox(width: 5),
                  ],
                )
              ],
            ));
      }
      return Container();
    });
  }
}
