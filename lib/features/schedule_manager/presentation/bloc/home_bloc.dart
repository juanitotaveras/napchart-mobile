import 'dart:async';

import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:rxdart/subjects.dart';

import 'home_event.dart';

class HomeBloc {
  HomeBloc() {
    _eventHandlerSubject.listen((HomeEvent event) {
      _handleEvent(event);
      timer = Timer.periodic(
          Duration(seconds: 1), (Timer t) => produceCurrentTime());
    });
  }
  // TODO: Load our schedule immediately
  /* We want the current time to be output as a stream every second (or minute),
 so that our UI can update accordingly */
  final _currentTimeStateController = StreamController<DateTime>();
  Stream<DateTime> get currentTime => _currentTimeStateController.stream;
  StreamSink<DateTime> get _inTime => _currentTimeStateController.sink;

  final viewModel = HomeViewModel();

  final _eventHandlerSubject = BehaviorSubject<HomeEvent>();
  Timer timer;

  void produceCurrentTime() {
    _inTime.add(DateTime.now());
  }

  void _handleEvent(HomeEvent event) async {
    print('le event: $event');
    if (event is LoadCurrentSchedule) {}
  }

  void dispatch(HomeEvent event) {
    _handleEvent(event);
  }

  void dispose() {
    _currentTimeStateController.close();
    viewModel.dispose();
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
