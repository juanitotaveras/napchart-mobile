import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  // If the subclasses have some properties, they'll get passed to this constructor
  // so that Equatable can perform value comparison.
  Failure([List properties = const <dynamic>[]]) : super(properties);
}

class PreferencesFailure extends Failure {}

class AssetsFailure extends Failure {}

class AndroidFailure extends Failure {}

class IOSFailure extends Failure {}

class GeneralFailure extends Failure {}
