import 'package:canteen_frontend/screens/home/bloc/home_event.dart';
import 'package:canteen_frontend/screens/home/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  int currentIndex = 0;

  HomeBloc();

  @override
  HomeState get initialState => PageLoading();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is PageTapped) {
      this.currentIndex = event.index;
      yield CurrentIndexChanged(currentIndex: this.currentIndex);
      yield PageLoading();

      switch (this.currentIndex) {
        case 0:
          yield RecommendedScreenLoaded();
          break;
        case 1:
          yield SearchScreenLoaded();
          break;
        case 2:
          yield RequestScreenLoaded();
          break;
        case 3:
          yield MatchScreenLoaded();
          break;
        case 4:
          yield UserProfileScreenLoaded();
          break;
      }
    }
  }
}
