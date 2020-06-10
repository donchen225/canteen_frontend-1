import 'dart:async';

import 'package:canteen_frontend/models/group/group.dart';
import 'package:canteen_frontend/models/group/group_repository.dart';
import 'package:canteen_frontend/models/recommendation/recommendation_repository.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/search/discover_bloc/discover_event.dart';
import 'package:canteen_frontend/screens/search/discover_bloc/discover_state.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final UserRepository _userRepository;
  final RecommendationRepository _recommendationRepository;
  final GroupRepository _groupRepository;
  List<User> _latestUsers = [];
  List<Group> _latestGroups = [];
  List<User> _recommendations = [];

  DiscoverBloc({
    @required UserRepository userRepository,
    @required RecommendationRepository recommendationRepository,
    @required GroupRepository groupRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository,
        _recommendationRepository = recommendationRepository,
        _groupRepository = groupRepository;

  @override
  DiscoverState get initialState => DiscoverUninitialized();

  @override
  Stream<DiscoverState> mapEventToState(
    DiscoverEvent event,
  ) async* {
    if (event is LoadDiscover) {
      yield* _mapLoadDiscoverToState(event);
    } else if (event is ClearDiscover) {
      yield* _mapClearDiscoverToState();
    }
  }

  Stream<DiscoverState> _mapLoadDiscoverToState(LoadDiscover event) async* {
    yield DiscoverLoading();

    final usersFuture = _latestUsers.length == 0
        ? _userRepository.getAllUsers()
        : Future.value(_latestUsers);

    final groupsFuture = _latestGroups.length == 0
        ? _groupRepository.getAllGroups(ignoreMainGroup: false)
        : Future.value(_latestGroups);

    await Future.wait<void>([
      usersFuture.then((users) => _latestUsers = users),
      _loadRecommended(),
      groupsFuture.then((groups) => _latestGroups = groups)
    ]);

    yield DiscoverLoaded(
        users: _latestUsers,
        recommendations: _recommendations,
        groups: _latestGroups);
  }

  Stream<DiscoverState> _mapClearDiscoverToState() async* {
    yield DiscoverUninitialized();
  }

  Future<void> _loadRecommended() async {
    final user = await _userRepository.currentUser();

    if (user.teachSkill.isEmpty && user.learnSkill.isEmpty) {
      return;
    }

    final recs = await _recommendationRepository.getRecommendations();

    recs.forEach((rec) {
      final exists = (_recommendations.firstWhere((r) => r.id == rec.userId,
          orElse: () => null));
      if (exists == null) {
        final user = User.fromRecommendation(rec);
        _recommendations.add(user);
      }
    });
  }
}
