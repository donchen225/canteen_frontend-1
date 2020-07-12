import 'package:bloc/bloc.dart';
import 'package:canteen_frontend/utils/app_config.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    if (AppConfig.logLevel == 'debug') {
      print(event);
    }
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (AppConfig.logLevel == 'debug') {
      print(transition);
    }
  }
}
