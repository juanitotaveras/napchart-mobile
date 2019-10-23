import 'dart:async';

import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:rxdart/subjects.dart';

class HomeBloc {
  // TODO: Load our schedule immediately
  /* We want the current time to be output as a stream every second (or minute),
 so that our UI can update accordingly */
  final _currentTimeStateController = StreamController<DateTime>();
  Stream<DateTime> get currentTime => _currentTimeStateController.stream;
  StreamSink<DateTime> get _inTime => _currentTimeStateController.sink;
  Timer timer;

  HomeBloc() {
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => produceCurrentTime());
  }

  void produceCurrentTime() {
    _inTime.add(DateTime.now());
  }

  void dispose() {
    _currentTimeStateController.close();
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

final bloc = HomeBloc();
