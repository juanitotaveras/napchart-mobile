import 'dart:async';

import 'package:polysleep/core/usecases/usecase.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/get_current_or_default_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/get_current_time.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/view_model_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:meta/meta.dart';

class HomeViewModel implements ViewModelBase {
  final GetCurrentOrDefaultSchedule getCurrentOrDefaultSchedule;
  final GetCurrentTime getCurrentTime;
  HomeViewModel(
      {@required this.getCurrentOrDefaultSchedule,
      @required this.getCurrentTime}) {
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => produceCurrentTime());
    onLoadSchedule();
  }

  /* ------- STREAMS  --------- */
  final currentScheduleSubject = BehaviorSubject<SleepSchedule>();
  Stream<SleepSchedule> get currentScheduleStream =>
      currentScheduleSubject.stream;
  SleepSchedule get currentSchedule => currentScheduleSubject.value;

  final selectedSegmentSubject = BehaviorSubject<int>.seeded(-1);
  Stream<int> get seletedSegmentStream => selectedSegmentSubject.stream;
  int get selectedSegment => selectedSegmentSubject.value;

  /* We want the current time to be output as a stream every second (or minute),
 so that our UI can update accordingly */
  final _currentTimeStateController = StreamController<DateTime>();
  Stream<DateTime> get currentTime => _currentTimeStateController.stream;
  StreamSink<DateTime> get _inTime => _currentTimeStateController.sink;

  Timer timer;

  void produceCurrentTime() {
    _inTime.add(this.getCurrentTime());
  }

  //! Event handlers
  void onLoadSchedule() async {
    final resp = await getCurrentOrDefaultSchedule(NoParams());
    resp.fold((failure) async {
      // currentScheduleSubject.add(null);
    }, (schedule) async {
      // get first segment which ends after current time
      currentScheduleSubject.add(_setDefaultSelectedSegment(schedule));
    });
  }

  void onRightNapArrowTapped() {}

  // ---- End event handlers

  //! Helper methods for state changes
  SleepSchedule _setDefaultSelectedSegment(SleepSchedule schedule) {
    final curTime = this.getCurrentTime();
    // This will make our currentTime default to 11/30 to make calculations easier
    final curSegTime = SegmentDateTime(hr: curTime.hour, min: curTime.minute);
    int minIdx = -1;
    int minDist = 2000000000000000000;
    for (int i = 0; i < schedule.segments.length; i++) {
      final seg = schedule.segments[i];
      // get seg that has an end time which is after current time
      // and closest to current time
      if (seg.endTime.isAfter(curSegTime) &&
          seg.endTime.difference(curTime).inMinutes < minDist) {
        minDist = seg.endTime.difference(curTime).inMinutes;
        minIdx = i;
      }
    }
    if (minIdx != -1) {
      final newSegs = schedule.segments
          .asMap()
          .map((index, seg) {
            return MapEntry(
                index,
                SleepSegment(
                    startTime: seg.startTime,
                    endTime: seg.endTime,
                    name: seg.name,
                    isSelected: index == minIdx));
          })
          .values
          .toList();
      return SleepSchedule(
          segments: newSegs,
          difficulty: schedule.difficulty,
          name: schedule.name);
    }
    return schedule;
  }

  SleepSchedule _setNextScheduleAsSelected() {
    int selectedIndex = -1;
    final schedule = this.currentSchedule;

    final newSegs = [];
    int nextIdx = -1;
    for (int i = 0; i < schedule.segments.length; i++) {
      final seg = schedule.segments[i];
      if (seg.isSelected) {
        // set next idx as selected
      } else if (i == nextIdx) {}
    }
    return schedule;
  }

  //! Calculated getters
  bool get shouldShowNapNavigationArrows => this.currentSchedule == null
      ? false
      : this.currentSchedule.segments.length > 1;

  //! Cleanup
  void dispose() {
    _currentTimeStateController.close();
    currentScheduleSubject.close();
    selectedSegmentSubject.close();
  }
}
