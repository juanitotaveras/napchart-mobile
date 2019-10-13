import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_bloc.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_event.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_state.dart';

class EditSegmentBottomSheetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final bloc = BlocProvider.of<ScheduleEditorBloc>(context);

    const cornerRadius = 5.0;
    const corner = Radius.circular(cornerRadius);
    return BlocBuilder<ScheduleEditorBloc, ScheduleEditorState>(
        builder: (BuildContext context, ScheduleEditorState state) {
      if (state is TemporarySegmentCreated) {
        print('XYZ');
        return Container(
            height: 140,
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
                        child: Text('Title: (le title)',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0))),
                    Container(alignment: Alignment.centerRight, width: 30.0)
                  ],
                ),

                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: <Widget>[
                        Text('Start time', style: TextStyle(fontSize: 14.0)),
                        Text('64:00am'),
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: <Widget>[
                        Text('End time', style: TextStyle(fontSize: 14.0)),
                        Text('12:00pm')
                      ],
                    ),
                    Expanded(child: Container()),
                    Column(
                      children: <Widget>[
                        Text('duration'),
                        Text(
                          'x hours',
                          textAlign: TextAlign.left,
                        )
                      ],
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 10),
                    RaisedButton(
                      onPressed: () {
                        print('delete pressed');
                      },
                      child: Text('Delete', style: TextStyle(fontSize: 20)),
                    ),
                    Expanded(child: Container()),
                    FlatButton(
                      onPressed: () {
                        print('saved pressed');
                      },
                      child: Text('Save', style: TextStyle(fontSize: 20)),
                    ),
                    SizedBox(width: 10),
                  ],
                )
              ],
            ));
      }
      return Container();
    });
  }
}
