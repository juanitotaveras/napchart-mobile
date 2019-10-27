import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/choose_template_view_model.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/view_model_provider.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/current_schedule_graphic.dart';
import 'package:polysleep/injection_container.dart';

class ChooseTemplatePage extends StatelessWidget {
  final _viewModel = sl<ChooseTemplateViewModel>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Choose a template')),
      body: ViewModelProvider(
          bloc: this._viewModel,
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: ListView(
                    children: <Widget>[templateChooserRow()],
                  )),
              Expanded(
                child: CurrentScheduleGraphic(
                  currentTime: DateTime.now(),
                  currentSchedule: SleepSchedule(name: "", segments: [
                    SleepSegment(
                        startTime: SegmentDateTime(hr: 1),
                        endTime: SegmentDateTime(hr: 3))
                  ]),
                ),
              )
            ],
          )),
    );
  }

  Widget templateChooserRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Text('Monophasic'),
        ),
        Expanded(child: Text('8h2m asleep')),
        Expanded(child: Text('Easy')),
        Expanded(child: Icon(Icons.info))
      ],
    );
  }
}
