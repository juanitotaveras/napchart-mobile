import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// used by the code calling the use case when
// use case doesn't accept any parameters.
class NoParams extends Equatable {}
