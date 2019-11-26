import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:polysleep/core/error/failure.dart';
import 'package:polysleep/core/usecases/usecase.dart';
import 'package:polysleep/features/schedule_manager/domain/repositories/schedule_editor_repository.dart';
import 'package:meta/meta.dart';

class SetAlarm extends UseCase<bool, Params> {
  final ScheduleEditorRepository repository;
  SetAlarm(this.repository);

  @override
  Future<Either<Failure, bool>> call(Params params) async {
    return await repository.setAlarm(params.ringTime);
  }
}

class Params extends Equatable {
  final DateTime ringTime;
  Params({@required this.ringTime}) : super([ringTime]);
}
