import 'package:canteen_frontend/services/navigation_service.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton(() => NavigationService());
}
