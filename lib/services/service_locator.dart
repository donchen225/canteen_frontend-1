import 'package:canteen_frontend/services/home_navigation_bar_service.dart';
import 'package:canteen_frontend/services/navigation_service.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton(() => NavigationService());
  getIt.registerLazySingleton(() => NavigationBarService());
}
