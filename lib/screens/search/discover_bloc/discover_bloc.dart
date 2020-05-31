import 'dart:async';

import 'package:canteen_frontend/models/recommendation/recommendation_repository.dart';
import 'package:canteen_frontend/models/search/search_query.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/search/discover_bloc/discover_event.dart';
import 'package:canteen_frontend/screens/search/discover_bloc/discover_state.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final UserRepository _userRepository;
  final RecommendationRepository _recommendationRepository;
  StreamSubscription _recommendedSubscription;
  List<User> _latestUsers = [];
  List<User> _searchResults = [];
  List<User> _recommendations = [];

  DiscoverBloc(
      {@required UserRepository userRepository,
      @required RecommendationRepository recommendationRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _recommendationRepository = recommendationRepository;

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

    if (_latestUsers.length == 0) {
      final users = await _userRepository.getAllUsers();
      _latestUsers = users;
    }

    await _loadRecommended();

    yield DiscoverLoaded(
        users: _latestUsers, recommendations: _recommendations);
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
