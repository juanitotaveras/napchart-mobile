import 'dart:math';
import 'package:polysleep/core/constants.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

class AngleCalculator {
  DateTime currentTime;
  SleepSegment segment;
  AngleCalculator(DateTime currentTime, SleepSegment segment) {
    if (currentTime == null) {
      var midnight = DateTime(2020, 1, 1, 0, 0, 0);
      this.currentTime = midnight;
    } else {
      this.currentTime = currentTime;
    }
    this.segment = segment;
  }

  double _getOffset() {
    // if this is 0, that means our center point is at 0 radians
    return pi / 2;
  }

  double getCurrentTimeRadians() {
    var currentMinutes = currentTime.hour * 60 + currentTime.minute;
    return (currentMinutes / MINUTES_PER_DAY) * 2 * pi;
  }

  double _getMidnightRadians() {
    return -1 * (getCurrentTimeRadians() + _getOffset());
  }

  double _getStartDistFromMidnight() {
    return (segment.getStartMinutesFromMidnight() / MINUTES_PER_DAY) * 2 * pi;
  }

  double getStartAngle() {
    return _getMidnightRadians() + _getStartDistFromMidnight();
  }

  double _getEndDistFromStart() {
    return (segment.getEndMinutesFromMidnight() / MINUTES_PER_DAY) * 2 * pi;
  }

  double getSweepAngle() {
    var angle = _getEndDistFromStart() - _getStartDistFromMidnight();
    if (!segment.startAndEndsOnSameDay()) {
      return 2 * pi - angle.abs();
    }
    return angle;
  }

  double getStartTimeRadians() {
    return getCurrentTimeRadians() - _getStartDistFromMidnight() + _getOffset();
  }

  double _getEndDistFromMidnight() {
    return (segment.getEndMinutesFromMidnight() / MINUTES_PER_DAY) * 2 * pi;
  }

  double getEndTimeRadians() {
    return getCurrentTimeRadians() - _getEndDistFromMidnight() + _getOffset();
  }

  Offset getStartTextOffset(Offset centerPoint, double radius) {
    // this is for translating the canvas when placing text
    if (_isInRightSideOfCircle(getStartTimeRadians())) {
      // Should increase offset if segment less than 30 min
      final denom = (this.segment.getDurationMinutes() <= 30) ? 1.09 : 1;
      return Offset(centerPoint.dx + (radius / 1.5), centerPoint.dy / denom);
    }
    final denom = (this.segment.getDurationMinutes() <= 30) ? 60 : 10;
    return Offset(
        centerPoint.dx - (radius / 1.1), centerPoint.dy - (radius / denom));
  }

  Offset getEndTextOffset(Offset centerPoint, double radius) {
    if (_isInRightSideOfCircle(getEndTimeRadians())) {
      final denom = (this.segment.getDurationMinutes() <= 30) ? 60 : 10;
      return Offset(
          centerPoint.dx + (radius / 1.5), centerPoint.dy - (radius / denom));
    }
    final denom = (this.segment.getDurationMinutes() <= 30) ? 1.09 : 1;
    return Offset(centerPoint.dx - (radius / 1.1), centerPoint.dy / denom);
  }

  double getStartTextAngle() {
    if (_isInRightSideOfCircle(getStartTimeRadians())) {
      return -getStartTimeRadians();
    }
    return -getStartTimeRadians() + pi;
  }

  double getEndTextAngle() {
    if (_isInRightSideOfCircle(getEndTimeRadians())) {
      return -getEndTimeRadians();
    }
    return -getEndTimeRadians() + pi;
  }

  bool _isInRightSideOfCircle(double angle) {
    // determines if angle is in quadrant 1 or 4
    if (angle < 0) {
      angle += 2 * pi;
    }
    return angle < (pi / 2) || angle > ((3 * pi) / 2);
  }
}
