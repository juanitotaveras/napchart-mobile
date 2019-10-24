import 'dart:ui';
import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  HomeEvent([List props = const <dynamic>[]]) : super(props);
}

class LoadCurrentSchedule extends HomeEvent {}
