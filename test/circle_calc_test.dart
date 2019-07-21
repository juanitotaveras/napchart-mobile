import 'package:polysleep/utils.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  group('Circle conversion calculations for graphics', () {
    test('get coord should calculate correct', () {
      Offset coord = Utils.getCoord(Offset(0.0, 0.0), 10, 0, 0);
      expect(10, coord.dx);
      expect(0, coord.dy);
    });
  });
}