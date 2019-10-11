import 'package:equatable/equatable.dart';

abstract class CurrentScheduleState extends Equatable {
  CurrentScheduleState([List props = const <dynamic>[]]) : super(props);
}

class InitialCurrentScheduleState extends CurrentScheduleState {
  @override
  List<Object> get props => [];
}
