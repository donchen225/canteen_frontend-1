import 'package:canteen_frontend/models/recommendation/recommendation.dart';
import 'package:canteen_frontend/models/recommendation/recommendation_repository.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/recommended/bloc/recommended_event.dart';
import 'package:canteen_frontend/screens/recommended/bloc/recommended_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class RecommendedBloc extends Bloc<RecommendedEvent, RecommendedState> {
  final UserRepository _userRepository;
  final RecommendationRepository _recommendationRepository;
  int _currentIndex = 0;
  List<Recommendation> _recommendations = [];

  RecommendedBloc(
      {@required UserRepository userRepository,
      @required RecommendationRepository recommendationRepository})
      : assert(userRepository != null),
        assert(recommendationRepository != null),
        _userRepository = userRepository,
        _recommendationRepository = recommendationRepository;

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
    final user = await _userRepository.currentUser();

    if (user.teachSkill.isEmpty && user.learnSkill.isEmpty) {
      yield RecommendedUnavailable();
    }

    final recommendations = (await _recommendationRepository
        .getRecommendations())
      ..retainWhere((rec) => rec.status == 0);

    recommendations.forEach((rec) {
      final exists = (_recommendations.firstWhere((r) => r.userId == rec.userId,
          orElse: () => null));
      if (exists == null) {
        _recommendations.add(rec);
      }
    });

    if (_currentIndex < _recommendations.length) {
      final rec = _recommendations[_currentIndex];
      final recUser = User.fromRecommendation(rec);

      yield RecommendedLoaded(rec, recUser);
    } else {
      yield RecommendedUnavailable();
    }
  }

  Stream<RecommendedState> _mapNextRecommendedToState() async* {
    yield RecommendedLoading();
    _currentIndex += 1;

    if (_currentIndex < _recommendations.length) {
      final rec = _recommendations[_currentIndex];
      final recUser = User.fromRecommendation(rec);
      yield RecommendedLoaded(rec, recUser);
    } else {
      yield RecommendedEmpty();
    }
  }
}
