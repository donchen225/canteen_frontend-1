import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/recommended/bloc/recommended_event.dart';
import 'package:canteen_frontend/screens/recommended/bloc/recommended_state.dart';
import 'package:canteen_frontend/utils/algolia.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class RecommendedBloc extends Bloc<RecommendedEvent, RecommendedState> {
  final UserRepository _userRepository;
  int _currentIndex = 0;
  List<User> _recommendations = [];

  RecommendedBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  RecommendedState get initialState => RecommendedLoading();

  @override
  Stream<RecommendedState> mapEventToState(RecommendedEvent event) async* {
    if (event is LoadRecommended) {
      yield* _mapLoadRecommendedToState();
    } else if (event is NextRecommended) {
      yield* _mapNextRecommendedToState();
    }
  }

  Stream<RecommendedState> _mapLoadRecommendedToState() async* {
    print('IN RECOMMENDED STATE');
    // final user = _userRepository.currentUserNow();
    final snapshot = await AlgoliaSearch.query('yoga');
    final recommendations = snapshot.hits
        .map((result) => User.fromAlgoliaSnapshot(result))
        .toList();
    _recommendations.addAll(recommendations);

    if (_currentIndex < _recommendations.length) {
      yield RecommendedLoaded(_recommendations[_currentIndex]);
    } else {
      yield RecommendedUnavailable();
    }
  }

  Stream<RecommendedState> _mapNextRecommendedToState() async* {
    yield RecommendedLoading();
    _currentIndex += 1;

    if (_currentIndex < _recommendations.length) {
      yield RecommendedLoaded(_recommendations[_currentIndex]);
    } else {
      yield RecommendedEmpty();
    }
  }
}
