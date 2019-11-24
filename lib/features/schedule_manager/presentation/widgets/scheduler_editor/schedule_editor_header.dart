import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/view_models/schedule_editor_view_model.dart';
import 'package:polysleep/features/schedule_manager/presentation/view_models/view_model_provider.dart';
import 'package:polysleep/features/schedule_manager/presentation/localizations.dart';
import 'package:polysleep/features/schedule_manager/presentation/pages/choose_template_page.dart';
import 'package:polysleep/features/schedule_manager/presentation/time_formatter.dart';

class ScheduleEditorHeaderPresenter {
  final _context;
  final ScheduleEditorViewModel _viewModel;
  ScheduleEditorHeaderPresenter(this._context, this._viewModel);

  int get _sleepMins => SleepSegment.getTotalSleepMinutes(
      this._viewModel.loadedSchedule.segments);
  String get asleepTime {
    return AppLocalizations.of(_context).awakeStart +
        TimeFormatter.formatSleepTime(_sleepMins);
  }

  int get _awakeMins => SleepSegment.getTotalAwakeMinutes(
      this._viewModel.loadedSchedule.segments);
  String get awakeTime {
    return asleepText + TimeFormatter.formatSleepTime(_awakeMins);
  }

  String get chooseScheduleButtonText =>
      AppLocalizations.of(_context).chooseScheduleButtonText;

  String get asleepText => AppLocalizations.of(_context).asleepStart;
}

class ScheduleEditorHeader extends StatelessWidget {
  void _goToChooseTemplatePage(
      _context, ScheduleEditorViewModel _viewModel) async {
    await Navigator.push(
        _context,
        MaterialPageRoute(
            builder: (context) => ChooseTemplatePage(_viewModel),
            fullscreenDialog: true));
    // _viewModel.onLoadSchedule();
  }

  @override
  Widget build(BuildContext context) {
    final _viewModel = ViewModelProvider.of<ScheduleEditorViewModel>(context);
    final presenter = ScheduleEditorHeaderPresenter(context, _viewModel);
    return StreamBuilder(
        stream: _viewModel.loadedScheduleStream,
        builder: (context, loadedSegmentsStream) {
          return Container(
            height: 60,
            width: double.infinity,
            padding: EdgeInsets.only(left: 30, right: 30),
            color: Colors.blueGrey,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment(-1.0, 0.0),
                  child:
                      /*Text(
                    presenter.chooseScheduleButtonText,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )*/
                      RaisedButton(
                          child: Text(presenter.chooseScheduleButtonText),
                          onPressed: () {
                            _goToChooseTemplatePage(context, _viewModel);
                          }),
                ),
                Align(
                    alignment: Alignment(1.0, -0.5),
                    child: Text(
                      presenter.asleepTime,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Align(
                    alignment: Alignment(1.0, 0.5),
                    child: Text(presenter.awakeTime,
                        textAlign: TextAlign.end,
                        style: TextStyle(fontWeight: FontWeight.bold)))
              ],
            ),
          );
        });
  }
}
