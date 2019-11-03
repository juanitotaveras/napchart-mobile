import 'package:polysleep/core/usecases/usecase.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/load_schedule_templates.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/save_current_schedule.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/view_model_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

class LoadedSchedulesState {
  final List<SleepSchedule> schedules;
  final int selectedIndex;
  LoadedSchedulesState({this.schedules, this.selectedIndex = -1});
}

class ChooseTemplateViewModel extends ViewModelBase {
  // need a currently selected schedule (which can be null)
  // need to load all schedules into memory
  final LoadScheduleTemplates loadScheduleTemplates;
  final SaveCurrentSchedule saveCurrentSchedule;
  ChooseTemplateViewModel(
      this.loadScheduleTemplates, this.saveCurrentSchedule) {
    assert(loadScheduleTemplates != null);

    loadTemplates();
  }

  final schedules = BehaviorSubject<LoadedSchedulesState>();
  final selectedScheduleSubject = BehaviorSubject<SleepSchedule>();

  void loadTemplates() async {
    final resp = await this.loadScheduleTemplates(NoParams());
    resp.fold((failure) async {
      print('SOME ERROR');
    }, (templates) async {
      schedules.add(LoadedSchedulesState(schedules: templates));
    });
  }

  void setIsSelected(int index) async {
    print('setting $index');
    schedules.add(LoadedSchedulesState(
        schedules: schedules.value.schedules, selectedIndex: index));
    selectedScheduleSubject.add(schedules.value.schedules[index]);
  }

  void onSaveSchedulePressed() async {
    // must call use case
    final resp = await saveCurrentSchedule(Params(
        schedule: schedules.value.schedules[schedules.value.selectedIndex]));
    resp.fold((failure) async {
      // print('there has been an error');
      // show error state
    }, (updatedSchedule) async {
      // print(' great success!');
      print(updatedSchedule);
      // currentScheduleSubject.add(schedule);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    schedules.close();
  }
}
