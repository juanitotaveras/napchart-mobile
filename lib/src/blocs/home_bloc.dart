import 'dart:async';
import 'package:polysleep/src/models/time.dart';
class HomeBloc {
  /* We want the current time to be output as a stream every second (or minute),
 so that our UI can update accordingly */
 final _currentTimeStateController = StreamController<Time>();
 Stream<Time> get currentTime => _currentTimeStateController.stream;


 void dispose() {
   _currentTimeStateController.close();
 }
}

final bloc = HomeBloc();