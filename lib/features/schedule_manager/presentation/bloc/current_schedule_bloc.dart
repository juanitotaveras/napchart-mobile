import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class CurrentScheduleBloc extends Bloc<CurrentScheduleEvent, CurrentScheduleState> {
  @override
  CurrentScheduleState get initialState => InitialCurrentScheduleState();

  @override
  Stream<CurrentScheduleState> mapEventToState(
    CurrentScheduleEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
