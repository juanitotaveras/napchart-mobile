/* Making this into a use case so I can mock it for unit tests. */

import 'package:dartz/dartz.dart';
import 'package:polysleep/core/error/failure.dart';
import 'package:polysleep/core/usecases/usecase.dart';

class GetCurrentTime {
  DateTime call() {
    return DateTime.now();
  }
}
