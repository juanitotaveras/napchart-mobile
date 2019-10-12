import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_bloc.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_state.dart';

class TemporarySegmentWidget extends StatelessWidget {
  final double marginLeft;
  final double marginRight;
  final int hourSpacing;
  static const cornerRadius = 10.0;
  static const corner = Radius.circular(cornerRadius);

  TemporarySegmentWidget({this.marginLeft, this.marginRight, this.hourSpacing});
  @override
  Widget build(BuildContext context) {
    print('le build temp seg');
    return BlocBuilder<ScheduleEditorBloc, ScheduleEditorState>(
        builder: (BuildContext context, ScheduleEditorState state) {
      if (state is TemporarySegmentExists) {
        final segment = state.segment;
        final topMargin =
            (hourSpacing * segment.startTime.hour + segment.startTime.minute)
                .toDouble();
        return Container(
            width: double.infinity,
            height: 60,
            // color: Colors.red,
            margin:
                EdgeInsets.fromLTRB(marginLeft, topMargin, marginRight, 0.0),
            child: GestureDetector(
                onTapUp: (TapUpDetails details) {
                  print('Tap on seg: ${details.globalPosition}');
                },
                child: renderContainerWithRoundedBorders()));
      } else {
        return Container();
      }
    });
  }

  Widget renderContainerWithRoundedBorders() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
              topLeft: corner,
              topRight: corner,
              bottomLeft: corner,
              bottomRight: corner)),
    );
  }
}
