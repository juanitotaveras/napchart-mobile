import 'dart:async';
import 'package:polysleep/src/models/time.dart';
class HomeBloc {
  /* We want the current time to be output as a stream every second (or minute),
 so that our UI can update accordingly */
 final _currentTimeStateController = StreamController<DateTime>();
 Stream<DateTime> get currentTime => _currentTimeStateController.stream;
 StreamSink<DateTime> get _inTime => _currentTimeStateController.sink;
 Timer timer;

 HomeBloc() {
   timer = Timer.periodic(Duration(seconds: 1), (Timer t) => produceCurrentTime());
 }

 DateTime produceCurrentTime() {
   print("DATETIME EVENT");
   print(DateTime.now());
   _inTime.add(DateTime.now());
 }

 void dispose() {
   _currentTimeStateController.close();
 }
}

final bloc = HomeBloc();