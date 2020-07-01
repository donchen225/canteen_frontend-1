import 'package:canteen_frontend/models/group/group_repository.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/home/bloc/home_event.dart';
import 'package:canteen_frontend/screens/home/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository _userRepository;
  final GroupRepository _groupRepository;

  HomeBloc(
      {@required UserRepository userRepository,
      @required GroupRepository groupRepository})
      : assert(userRepository != null),
        assert(groupRepository != null),
        _userRepository = userRepository,
        _groupRepository = groupRepository;

  @override
  HomeState get initialState => HomeUninitialized();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is CheckOnboardStatus) {
      yield* _mapCheckOnboardStatusToState();
    } else if (event is InitializeHome) {
      yield* _mapInitializeHomeToState();
    } else if (event is ClearHome) {
      yield* _mapClearHomeToState();
    }
  }

  Stream<HomeState> _mapCheckOnboardStatusToState() async* {
    final user = await _userRepository.currentUser();

    final authenticated = user == null;

    yield HomeLoaded(authenticated: authenticated);
    // if (user.onBoarded != null && user.onBoarded == 1) {
    //   yield HomeLoaded();
    // } else {
    //   yield OnboardScreenLoaded();
    // }
  }

  Stream<HomeState> _mapInitializeHomeToState() async* {
    yield HomeLoading();

    try {
      await _groupRepository.joinGroup("HxuOLXcLsIBmTxp0ToiQ");
    } catch (e) {
      print('Error joining Canteen group: $e');
    }

    yield HomeLoaded(authenticated: true);
  }

  Stream<HomeState> _mapClearHomeToState() async* {
    yield HomeLoaded(authenticated: false);
  }
}
