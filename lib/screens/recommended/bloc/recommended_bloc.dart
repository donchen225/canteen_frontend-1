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
  List<User> recommendations = [];

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
    } else if (event is ClearRecommended) {
      yield* _mapClearRecommendedToState();
    }
  }

  Stream<RecommendedState> _mapLoadRecommendedToState() async* {
    yield RecommendedLoading();

    final user = await _userRepository.currentUser();

    if (user.teachSkill.isEmpty && user.learnSkill.isEmpty) {
      yield RecommendedUnavailable();
    }

    final recs = await _recommendationRepository.getRecommendations();
    final newRecs = recs.where((rec) => rec.status == 0);

    newRecs.forEach((rec) {
      final exists = (recommendations.firstWhere((r) => r.id == rec.userId,
          orElse: () => null));
      if (exists == null) {
        final user = User.fromRecommendation(rec);
        recommendations.add(user);
      }
    });

    if (recommendations != null && recommendations.isNotEmpty) {
      yield RecommendedLoaded(recommendations);
    } else {
      yield RecommendedUnavailable();
    }
  }

  // Stream<RecommendedState> _mapNextRecommendedToState() async* {
  //   yield RecommendedLoading();

  //   final currentRec = recommendations[currentIndex];
  //   _recommendationRepository.declineRecommendation(currentRec.id);

  //   currentIndex += 1;

  //   if (currentIndex < recommendations.length) {
  //     final rec = recommendations[currentIndex];
  //     final recUser = User.fromRecommendation(rec);
  //     yield RecommendedLoaded(rec, recUser);
  //   } else {
  //     yield RecommendedEmpty();
  //   }
  // }

  // Stream<RecommendedState> _mapAcceptRecommendedToState() async* {
  //   yield RecommendedLoading();

  //   final currentRec = recommendations[currentIndex];
  //   _recommendationRepository.acceptRecommendation(currentRec.id);

  //   currentIndex += 1;

  //   if (currentIndex < recommendations.length) {
  //     final rec = recommendations[currentIndex];
  //     final recUser = User.fromRecommendation(rec);
  //     yield RecommendedLoaded(rec, recUser);
  //   } else {
  //     yield RecommendedEmpty();
  //   }
  // }

  Stream<RecommendedState> _mapClearRecommendedToState() async* {
    recommendations = [];
    yield RecommendedLoading();
  }
}
