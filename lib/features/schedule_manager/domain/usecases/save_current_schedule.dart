import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/alarm_info.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/repositories/schedule_editor_repository.dart';
import '../repositories/schedule_editor_repository.dart';
import 'package:meta/meta.dart';
import 'package:polysleep/core/error/failure.dart';
import 'package:polysleep/core/usecases/usecase.dart';

class SaveCurrentSchedule extends UseCase<void, Params> {
  final ScheduleRepository scheduleRepository;

  SaveCurrentSchedule(this.scheduleRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    // TODO: We should compare new schedule with initial schedule.
    // If we delete alarms, they must be cleared from the platform.
    final prevAlarmMap = _createAlarmMap(params.previousSchedule);
    final newAlarmMap = _createAlarmMap(params.newSchedule);
    prevAlarmMap.entries.forEach((MapEntry<int, AlarmInfo> code) {
      if (newAlarmMap.containsKey(code.key)) {
        final prevAlarm = code.value;
        final newAlarm = newAlarmMap[code.key];
        if (prevAlarm.isOn && !newAlarm.isOn) {
          scheduleRepository.deleteAlarm(newAlarm);
        }
      } else {
        // new alarms do not contain the old alarm, so it has been deleted.
        scheduleRepository.deleteAlarm(code.value);
      }
    });
    return await scheduleRepository.putCurrentSchedule(params.newSchedule);
  }

  Map<int, AlarmInfo> _createAlarmMap(SleepSchedule schedule) {
    List<AlarmInfo> alarmList =
        schedule.segments.map((seg) => seg.alarmInfo).toList();

    Map<int, AlarmInfo> map = Map();
    alarmList.forEach((alarmInfo) {
      if (alarmInfo.alarmCode != null) {
        map.putIfAbsent(alarmInfo.alarmCode, () => alarmInfo);
      }
    });
    return map;
  }
}

class Params extends Equatable {
  final SleepSchedule newSchedule;
  final SleepSchedule previousSchedule;
  Params({@required this.newSchedule, @required this.previousSchedule})
      : super([newSchedule, previousSchedule]);
}
