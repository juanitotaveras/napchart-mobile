import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/get_current_or_default_schedule.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/home_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/view_model_provider.dart';
import 'package:polysleep/features/schedule_manager/presentation/pages/home_page.dart';
import 'package:polysleep/injection_container.dart' as di;

class MockHomeModel extends Mock implements HomeViewModel {}

void main() {
  // TODO: We need to mock our model,
  // and when the page calls sl<HomeViewHome>,
  // we must return our mocked model
  /*
Should we pass our model into our home page? That way we can pass in
a mock...
  */
  group('home page functionality', () {
    setUp(() async {
      await di.init();
    });

    testWidgets('Should only show forward/back buttons if at least 2 segments',
        (WidgetTester tester) async {
      final widget = MyHomePage(title: 'Test title');
      final w = MaterialApp(home: Scaffold(body: widget));
      await tester.pumpWidget(w);
    });
  });
}
