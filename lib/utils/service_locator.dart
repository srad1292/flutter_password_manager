import 'package:get_it/get_it.dart';
import 'package:password_manager/modules/shared/service/password.dart';
import 'package:password_manager/modules/shared/service/settings.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton(() => PasswordService());
  serviceLocator.registerLazySingleton(() => SettingsService());
}