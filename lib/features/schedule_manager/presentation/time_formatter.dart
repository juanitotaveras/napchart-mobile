import 'package:intl/intl.dart';

class TimeFormatter {
// Note: We will later need to check preferences to see
// if user wants military time or American time
  String getMilitaryTime(DateTime dt) {
    var formatter = new DateFormat('Hm');
    String formatted = formatter.format(dt);
    return formatted;
  }

  static String formatSleepTime(int sleepMin) {
    int h = sleepMin ~/ 60;
    int m = sleepMin % 60;
    String res = '';
    if (h > 0) res += '${h}h';
    if (m > 0) {
      if (res.length > 0) res += ' ';
      res += '${m}m';
    }
    return res;
  }

  String formatNapCountdown(int sleepSec) {
    int h = sleepSec ~/ (60 * 60);
    int m = (sleepSec - h * 60 * 60) ~/ (60);
    int s = (sleepSec - m * 60) % (60 * 60);
    return '$h:$m:$s';
  }
}
