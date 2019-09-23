import 'package:intl/intl.dart';

class TimeFormatter {
  final DateTime dt;
  TimeFormatter(this.dt);

// Note: We will later need to check preferences to see
// if user wants military time or American time
  String getMilitaryTime() {
    var formatter = new DateFormat('Hm');
    String formatted = formatter.format(dt);
    return formatted;
  }
}
