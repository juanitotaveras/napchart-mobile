import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/bloc.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/choose_template_view_model.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/view_model_provider.dart';
import 'package:polysleep/features/schedule_manager/presentation/localizations.dart';
import 'package:polysleep/features/schedule_manager/presentation/widgets/current_schedule_graphic.dart';
import 'package:polysleep/injection_container.dart';

class ChooseTemplatePresenter {
  final _context;
  final ChooseTemplateViewModel _viewModel;
  ChooseTemplatePresenter(this._context, this._viewModel);

  String get pageHeader =>
      AppLocalizations.of(_context).chooseTemplatePageHeader;

  String formatSleepTime(int sleepMin) {
    int h = sleepMin ~/ 60;
    int m = sleepMin % 60;
    return '${h}h ${m}m';
  }
}

class ChooseTemplatePage extends StatelessWidget {
  ChooseTemplatePage(this._seBloc);
  final ScheduleEditorViewModel _seBloc;
  final _viewModel = sl<ChooseTemplateViewModel>();
  ChooseTemplatePresenter presenter;
  @override
  Widget build(BuildContext context) {
    presenter = ChooseTemplatePresenter(context, _viewModel);
    return Scaffold(
      appBar: AppBar(
        title: Text(presenter.pageHeader),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              // _viewModel.onSaveSchedulePressed();
              _seBloc.onTemplateScheduleSet(
                  _viewModel.selectedScheduleSubject.value);
              Navigator.pop(context, false);
            },
            child: Text("DONE"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: ViewModelProvider(bloc: this._viewModel, child: pageBody()),
    );
  }

  Widget templateChooserRow(SleepSchedule schedule, int index,
      {isSelected = false}) {
    return InkWell(
        onTap: () {
          print('tapped!');
          _viewModel.setIsSelected(index);
        },
        child: Container(
            padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
            decoration: BoxDecoration(
                color: isSelected ? Colors.red : Colors.transparent,
                border: Border(
                    bottom: BorderSide(color: Colors.white30, width: 1))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Text(
                    schedule.name,
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(presenter
                            .formatSleepTime(schedule.totalSleepMinutes)),
                      ],
                    )),
                Expanded(child: Text(schedule.difficulty)),
                Expanded(child: Icon(Icons.info))
              ],
            )));
  }

  Widget scheduleList(List<Widget> templateRows) => ListView(
        children: templateRows,
      );

  Widget scheduleGraphic() {
    return StreamBuilder<SleepSchedule>(
      stream: _viewModel.selectedScheduleSubject.stream,
      initialData: null,
      builder: (context, selectedScheduleStream) {
        return CurrentScheduleGraphic(
            currentTime: SegmentDateTime(hr: 0),
            currentSchedule: selectedScheduleStream.data);
      },
    );
  }

  Widget pageBody() {
    return StreamBuilder<LoadedSchedulesState>(
        stream: _viewModel.schedules.stream,
        initialData: null,
        builder: (context, loadedStream) {
          final List<Widget> templateRows = [];
          final schedules = loadedStream.data.schedules;
          if (schedules != null) {
            var idx = 0;
            schedules.forEach((SleepSchedule sched) {
              templateRows.add(templateChooserRow(sched, idx,
                  isSelected: loadedStream.data.selectedIndex == idx));
              idx++;
            });
          }
          if (_viewModel.selectedSchedule == null) {
            return Container(
                padding: EdgeInsets.only(top: 10),
                child: scheduleList(templateRows));
          }
          return Column(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                      padding: EdgeInsets.only(top: 10),
                      child: scheduleList(templateRows)
                      /* dataTable(schedules)*/)),
              Expanded(child: scheduleGraphic())
            ],
          );
        });
  }
}
