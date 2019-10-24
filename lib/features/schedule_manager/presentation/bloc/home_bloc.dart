import 'dart:async';

import 'package:polysleep/core/usecases/usecase.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/get_current_or_default_schedule.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/current_schedule_model.dart';
import 'package:rxdart/subjects.dart';

import 'home_event.dart';

class HomeBloc {
  HomeBloc(this.getCurrentOrDefaultSchedule) {
    _eventHandlerSubject.listen((HomeEvent event) {
      _handleEvent(event);
      timer = Timer.periodic(
          Duration(seconds: 1), (Timer t) => produceCurrentTime());
    });
  }

  final GetCurrentOrDefaultSchedule getCurrentOrDefaultSchedule;
  // TODO: Load our schedule immediately
  /* We want the current time to be output as a stream every second (or minute),
 so that our UI can update accordingly */
  final _currentTimeStateController = StreamController<DateTime>();
  Stream<DateTime> get currentTime => _currentTimeStateController.stream;
  StreamSink<DateTime> get _inTime => _currentTimeStateController.sink;

  final viewModel = HomeViewModel();
  final currentScheduleModel = CurrentScheduleModel();

  final _eventHandlerSubject =
      BehaviorSubject<HomeEvent>.seeded(LoadCurrentSchedule());
  Timer timer;

  void produceCurrentTime() {
    _inTime.add(DateTime.now());
  }

  void _handleEvent(HomeEvent event) async {
    if (event is LoadCurrentSchedule) {
      final resp = await getCurrentOrDefaultSchedule(NoParams());
      resp.fold((failure) async {
        // viewModel.currentScheduleSubject.add(null);
      }, (schedule) async {
        // viewModel.currentScheduleSubject.add(schedule);
        currentScheduleModel.currentScheduleSubject.add(schedule);
      });
    }
  }

  void dispatch(HomeEvent event) {
    _handleEvent(event);
  }

  void dispose() {
    _currentTimeStateController.close();
    viewModel.dispose();
    currentScheduleModel.dispose();
  }
}

class HomeViewModel {
  final currentScheduleSubject = BehaviorSubject<SleepSchedule>();
  Stream<SleepSchedule> get currentScheduleStream =>
      currentScheduleSubject.stream;
  SleepSchedule get currentSchedule => currentScheduleSubject.value;

  dispose() {
    currentScheduleSubject.close();
  }
}

// final bloc = HomeBloc();
