import 'dart:async';

import 'package:canteen_frontend/models/discover/discover_repository.dart';
import 'package:canteen_frontend/models/discover/popular_user.dart';
import 'package:canteen_frontend/models/group/group.dart';
import 'package:canteen_frontend/models/group/group_repository.dart';
import 'package:canteen_frontend/models/recommendation/recommendation_repository.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/search/discover_bloc/discover_event.dart';
import 'package:canteen_frontend/screens/search/discover_bloc/discover_state.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/iterables.dart';
import 'package:tuple/tuple.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final UserRepository _userRepository;
  final DiscoverRepository _discoverRepository;
  final RecommendationRepository _recommendationRepository;
  final GroupRepository _groupRepository;
  List<Tuple2<PopularUser, User>> _popularUsers = [];
  List<Group> _latestGroups = [];
  List<User> _recommendations = [];

  DiscoverBloc({
    @required UserRepository userRepository,
    @required DiscoverRepository discoverRepository,
    @required RecommendationRepository recommendationRepository,
    @required GroupRepository groupRepository,
  })  : assert(userRepository != null),
        assert(discoverRepository != null),
        _userRepository = userRepository,
        _discoverRepository = discoverRepository,
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

    List<Future> futureList = [];
    if (_popularUsers.length == 0) {
      try {
        final popularUsers = await _discoverRepository.getPopularUsers();

        if (popularUsers != null) {
          popularUsers.sort((a, b) => a.rank.compareTo(b.rank));

          futureList.add(Future.wait(
                  popularUsers.map((user) => _userRepository.getUser(user.id)))
              .then((users) {
            _popularUsers = zip([popularUsers, users])
                .map((entry) => Tuple2<PopularUser, User>(entry[0], entry[1]))
                .toList();
          }));
        }
      } catch (error) {
        print('Error loading popular users: $error');
      }
    }

    if (_latestGroups.length == 0) {
      futureList.add(_groupRepository
          .getAllGroups(ignoreMainGroup: false)
          .then((groups) => _latestGroups = groups));
    }

    futureList.add(_loadRecommended());

    await Future.wait<void>(futureList);

    yield DiscoverLoaded(
        popularUsers: _popularUsers,
        recommendations: _recommendations,
        groups: _latestGroups);
  }

  Stream<DiscoverState> _mapClearDiscoverToState() async* {
    yield DiscoverUninitialized();
  }

  Future<void> _loadRecommended() async {
    final user = await _userRepository.currentUser();

    if (user == null) {
      return;
    }

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
