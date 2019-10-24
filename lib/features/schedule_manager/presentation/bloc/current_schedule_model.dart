import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:rxdart/subjects.dart';

class CurrentScheduleModel {
  static final _instance = CurrentScheduleModel._internal();

  factory CurrentScheduleModel() {
    _instance.activeListeners += 1;
    return _instance;
  }

  final currentScheduleSubject = BehaviorSubject<SleepSchedule>();
  Stream<SleepSchedule> get currentScheduleStream =>
      currentScheduleSubject.stream;
  SleepSchedule get currentSchedule => currentScheduleSubject.value;

  var activeListeners = 0;
  CurrentScheduleModel._internal() {
    activeListeners = 0;
  }

  void dispose() {
    if (_instance.activeListeners == 0) {
      // close streams
      currentScheduleSubject.close();
    } else {
      _instance.activeListeners -= 1;
    }
  }
}
