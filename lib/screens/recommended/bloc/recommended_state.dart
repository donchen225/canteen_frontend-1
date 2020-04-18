import 'package:canteen_frontend/models/recommendation/recommendation.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';

abstract class RecommendedState extends Equatable {
  const RecommendedState();

  @override
  List<Object> get props => [];
}

class RecommendedLoading extends RecommendedState {}

class RecommendedLoaded extends RecommendedState {
  final Recommendation rec;
  final User user;

  const RecommendedLoaded(this.rec, this.user);

  @override
  List<Object> get props => [user, rec];

  @override
  String toString() {
    return 'RecommendedLoaded { user: $user, rec: $rec }';
  }
}

class RecommendedEmpty extends RecommendedState {}

class RecommendedUnavailable extends RecommendedState {}
