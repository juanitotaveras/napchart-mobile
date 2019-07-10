import 'dart:math';

class Time {
  int hr, min, sec;
  Time(this.hr, this.min, this.sec);

  double toRadians() {
    int currentSeconds = hr*60*60 + min*60 + sec;
    int SECONDS_PER_DAY = 24*60*60;
    return (currentSeconds * 2 * pi) / SECONDS_PER_DAY;
  }

  static Time fromDateTime(DateTime dt) {
    return Time(dt.hour, dt.minute, dt.second);
  }
}