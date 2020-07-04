import 'package:canteen_frontend/models/api_response/api_response_status.dart';
import 'package:canteen_frontend/models/group/group_repository.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/home/bloc/home_event.dart';
import 'package:canteen_frontend/screens/home/bloc/home_state.dart';
import 'package:canteen_frontend/utils/app_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository _userRepository;
  final GroupRepository _groupRepository;
  DateTime _lastRequested;

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
    } else if (event is UserHomeLoaded) {
      yield* _mapUserHomeLoadedToState();
    } else if (event is LoadHome) {
      yield* _mapLoadHomeToState();
    } else if (event is ClearHome) {
      yield* _mapClearHomeToState();
    }
  }

  Stream<HomeState> _mapCheckOnboardStatusToState() async* {
    final user = await _userRepository.currentUser();

    if (user == null) {
      yield HomeLoaded(authenticated: false);
    } else if (user.onBoarded == null || user.onBoarded != 1) {
      yield OnboardScreenLoaded();
    } else {
      final time = DateTime.now();
      _lastRequested = time;
      yield HomeLoaded(authenticated: true, lastRequested: time);
    }
  }

  Stream<HomeState> _mapInitializeHomeToState() async* {
    yield HomeLoading();

    try {
      final response =
          await _groupRepository.joinGroup(AppConfig.defaultGroupId);

      if (response.status != ApiResponseStatus.success) {
        throw Exception(response.message);
      }
    } catch (e) {
      print('Error joining Canteen group: $e');
    }

    yield HomeLoaded(authenticated: true);
  }

  Stream<HomeState> _mapUserHomeLoadedToState() async* {
    yield HomeLoaded(
        authenticated: true, dataLoaded: true, lastRequested: _lastRequested);
  }

  Stream<HomeState> _mapLoadHomeToState() async* {
    final time = DateTime.now();
    _lastRequested = time;

    yield HomeLoaded(
        authenticated: true, dataLoaded: false, lastRequested: time);
  }

  Stream<HomeState> _mapClearHomeToState() async* {
    yield HomeLoaded(authenticated: false);
  }
}
