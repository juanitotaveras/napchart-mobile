import 'package:flutter/services.dart' as prefix0;
import 'package:get_it/get_it.dart';
import 'package:polysleep/features/schedule_manager/data/datasources/android_platform_source.dart';
import 'package:polysleep/features/schedule_manager/data/datasources/assets_data_source.dart';
import 'package:polysleep/features/schedule_manager/data/datasources/ios_platform_source.dart';
import 'package:polysleep/features/schedule_manager/data/datasources/preferences_data_source.dart';
import 'package:polysleep/features/schedule_manager/data/repositories/platform_repository_impl.dart';
import 'package:polysleep/features/schedule_manager/data/repositories/schedule_editor_repository_impl.dart';
import 'package:polysleep/features/schedule_manager/domain/repositories/platform_repository.dart';
import 'package:polysleep/features/schedule_manager/domain/repositories/schedule_editor_repository.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/get_default_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/save_current_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/set_alarm.dart';
import 'package:polysleep/features/schedule_manager/presentation/view_models/choose_template_view_model.dart';
import 'package:polysleep/features/schedule_manager/presentation/view_models/edit_alarm_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/schedule_manager/domain/usecases/get_current_or_default_schedule.dart';
import 'features/schedule_manager/domain/usecases/get_current_schedule.dart';
import 'features/schedule_manager/domain/usecases/get_current_time.dart';
import 'features/schedule_manager/domain/usecases/load_schedule_templates.dart';
import 'features/schedule_manager/presentation/view_models/home_view_model.dart';
import 'features/schedule_manager/presentation/view_models/schedule_editor_view_model.dart';

// sl stands for Service Locator
final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Schedule Editor
  // Bloc
  sl.registerFactory(() => ScheduleEditorViewModel(
        getCurrentOrDefaultSchedule: sl(),
        saveCurrentSchedule: sl(),
      ));
  sl.registerFactory(() =>
      HomeViewModel(getCurrentOrDefaultSchedule: sl(), getCurrentTime: sl()));
  sl.registerFactory(() => ChooseTemplateViewModel(sl(), sl()));
  sl.registerFactory(() => EditAlarmViewModel(setAlarm: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetCurrentSchedule(sl()));
  sl.registerLazySingleton(() => GetDefaultSchedule(sl()));
  sl.registerLazySingleton(() => SaveCurrentSchedule(sl()));
  sl.registerLazySingleton(() => GetCurrentOrDefaultSchedule(sl(), sl(), sl()));
  sl.registerLazySingleton(() => LoadScheduleTemplates(sl()));
  sl.registerLazySingleton(() => GetCurrentTime());
  sl.registerLazySingleton(() => SetAlarm(sl(), sl()));

  // Repository
  sl.registerLazySingleton<ScheduleRepository>(() => ScheduleRepositoryImpl(
      preferencesDataSource: sl(), assetsDataSource: sl()));
  sl.registerLazySingleton<PlatformRepository>(() => PlatformRepositoryImpl(
      androidPlatformSource: sl(), iOSPlatformSource: sl()));

  // Data sources
  sl.registerLazySingleton<PreferencesDataSource>(
      () => PreferencesDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<AssetsDataSource>(
      () => AssetsDataSourceImpl(rootBundle: sl()));
  sl.registerLazySingleton<AndroidPlatformSourceImpl>(
      () => AndroidPlatformSourceImpl());
  sl.registerLazySingleton<IOSPlatformSourceImpl>(
      () => IOSPlatformSourceImpl());

  //! Core

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  final rootBundle = prefix0.rootBundle;
  sl.registerLazySingleton(() => rootBundle);
}
