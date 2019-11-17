import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class NotificationInfo extends Equatable {
  final bool isOn;
  final DateTime notifyTime;

  NotificationInfo({@required this.isOn, @required this.notifyTime});

  static NotificationInfo createDefaultUsingTime(DateTime startTime) {
    // TODO: Make this occur 5 min before start time
    return NotificationInfo(isOn: false, notifyTime: startTime);
  }
}
