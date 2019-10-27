import 'package:polysleep/core/usecases/usecase.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/load_schedule_templates.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/view_model_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

class ChooseTemplateViewModel extends ViewModelBase {
  // need a currently selected schedule (which can be null)
  // need to load all schedules into memory
  final LoadScheduleTemplates loadScheduleTemplates;
  ChooseTemplateViewModel(this.loadScheduleTemplates) {
    assert(loadScheduleTemplates != null);

    loadTemplates();
  }

  final schedules = PublishSubject<List<SleepSchedule>>();

  void loadTemplates() async {
    final resp = await this.loadScheduleTemplates(NoParams());
    resp.fold((failure) async {
      print('SOME ERROR');
    }, (templates) async {
      schedules.add(templates);
      print('templates');
      templates.forEach((f) => print(f));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    schedules.close();
  }
}
