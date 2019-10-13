import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_bloc.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_event.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_state.dart';
import 'package:intl/intl.dart';

class EditSegmentBottomSheetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final bloc = BlocProvider.of<ScheduleEditorBloc>(context);

    const cornerRadius = 5.0;
    const corner = Radius.circular(cornerRadius);
    return BlocBuilder<ScheduleEditorBloc, ScheduleEditorState>(
        builder: (BuildContext context, ScheduleEditorState state) {
      if (state is TemporarySegmentCreated || state is SelectedSegmentChanged) {
        print('XYZ');
        final SleepSegment segment = (state as dynamic).segment;
        final DateFormat formatter = DateFormat('Hm');
        return Container(
            height: 130,
            // color: Colors.blue,
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius:
                    BorderRadius.only(topLeft: corner, topRight: corner)),
            child: Column(
              children: <Widget>[
                // ListTile(title: Text('SOME STUFF'))
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
                        Text('${formatter.format(segment.startTime)}'),
                      ],
                    ),
                    Expanded(child: Container()),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('End time', style: TextStyle(fontSize: 14.0)),
                        Text('${formatter.format(segment.endTime)}')
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
                        print('saved pressed');
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
