import 'package:flutter/services.dart' as prefix0;
import 'package:get_it/get_it.dart';
import 'package:polysleep/features/schedule_manager/data/datasources/assets_data_source.dart';
import 'package:polysleep/features/schedule_manager/data/datasources/preferences_data_source.dart';
import 'package:polysleep/features/schedule_manager/data/repositories/schedule_editor_repository_impl.dart';
import 'package:polysleep/features/schedule_manager/domain/repositories/schedule_editor_repository.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/get_default_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/save_current_schedule.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/schedule_manager/domain/usecases/get_current_schedule.dart';
import 'features/schedule_manager/presentation/bloc/schedule_editor_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Schedule Editor
  // Bloc
  sl.registerFactory(() => ScheduleEditorBloc(
        getCurrentSchedule: sl(),
        getDefaultSchedule: sl(),
        saveCurrentSchedule: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetCurrentSchedule(sl()));
  sl.registerLazySingleton(() => GetDefaultSchedule(sl()));
  sl.registerLazySingleton(() => SaveCurrentSchedule(sl()));

  // Repository
  sl.registerLazySingleton<ScheduleEditorRepository>(() =>
      ScheduleEditorRepositoryImpl(
          preferencesDataSource: sl(), assetsDataSource: sl()));

  // Data sources
  sl.registerLazySingleton<PreferencesDataSource>(
      () => PreferencesDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<AssetsDataSource>(
      () => AssetsDataSourceImpl(rootBundle: sl()));

  //! Core

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  final rootBundle = prefix0.rootBundle;
  sl.registerLazySingleton(() => rootBundle);
}
