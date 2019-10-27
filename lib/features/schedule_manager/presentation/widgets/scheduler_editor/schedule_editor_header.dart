import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/schedule_editor_bloc.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/view_model_provider.dart';
import 'package:polysleep/features/schedule_manager/presentation/localizations.dart';
import 'package:polysleep/features/schedule_manager/presentation/pages/choose_template_page.dart';

class ScheduleEditorHeaderPresenter {
  final _context;
  final ScheduleEditorBloc _viewModel;
  ScheduleEditorHeaderPresenter(this._context, this._viewModel);

  int get _sleepMins =>
      SleepSegment.getTotalSleepMinutes(this._viewModel.loadedSegments);
  int get _sleepH => _sleepMins ~/ 60;
  int get _sleepM => _sleepMins - (_sleepMins ~/ 60) * 60;
  String get sleepTime {
    return AppLocalizations.of(_context).awakeStart +
        _sleepH.toString() +
        " hrs " +
        _sleepM.toString() +
        " mins";
  }

  int get _awakeMins =>
      SleepSegment.getTotalAwakeMinutes(this._viewModel.loadedSegments);
  int get _awakeH => _awakeMins ~/ 60;
  int get _awakeM => _awakeMins - (_awakeMins ~/ 60) * 60;
  String get awakeTime {
    return asleepText +
        _awakeH.toString() +
        " hrs " +
        _awakeM.toString() +
        " mins";
  }

  String get chooseScheduleButtonText =>
      AppLocalizations.of(_context).chooseScheduleButtonText;

  String get asleepText => AppLocalizations.of(_context).asleepStart;
}

class ScheduleEditorHeader extends StatelessWidget {
  void _goToChooseTemplatePage(_context) async {
    await Navigator.push(
        _context,
        MaterialPageRoute(
            builder: (context) => ChooseTemplatePage(),
            fullscreenDialog: true));
  }

  @override
  Widget build(BuildContext context) {
    final _viewModel = ViewModelProvider.of<ScheduleEditorBloc>(context);
    final presenter = ScheduleEditorHeaderPresenter(context, _viewModel);
    return StreamBuilder(
        stream: _viewModel.loadedSegmentsStream,
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
                            _goToChooseTemplatePage(context);
                          }),
                ),
                Align(
                    alignment: Alignment(1.0, -0.5),
                    child: Text(
                      presenter.sleepTime,
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
