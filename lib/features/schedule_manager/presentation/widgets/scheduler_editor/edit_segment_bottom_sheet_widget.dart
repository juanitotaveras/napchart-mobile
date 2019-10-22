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
  String getDurationText();
}

class _ViewModel {
  String startTime;
  String endTime;
  String duration;
  String durationText;
}

class EditSegmentBottomSheetPresenter extends EditBottomSheetView {
  final SleepSegment selectedSegment;
  final _ViewModel vm = _ViewModel();
  EditSegmentBottomSheetPresenter(this.selectedSegment) {
    vm.startTime = formatter.format(selectedSegment.startTime);
    vm.endTime = formatter.format(selectedSegment.endTime);
    vm.durationText = 'Duration';
    // AppLocalizations.of(context).duration
  }

  final DateFormat formatter = DateFormat('Hm');
  @override
  String getStartTime() => vm.startTime;

  @override
  String getEndTime() => vm.endTime;

  @override
  String getDurationText() => vm.durationText;
}

class EditSegmentBottomSheetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ScheduleEditorBloc>(context);

    const cornerRadius = 5.0;
    const corner = Radius.circular(cornerRadius);

    return StreamBuilder<SleepSegment>(
      stream: bloc.selectedSegmentStream,
      initialData: null,
      builder: (context, snapshot) {
        final selectedSegment = snapshot.data;
        if (selectedSegment != null) {
          final presenter = EditSegmentBottomSheetPresenter(selectedSegment);
          final SleepSegment segment = selectedSegment;

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
                          Text(presenter.getDurationText()),
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
      },
    );
  }
}
