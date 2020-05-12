import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';

abstract class RecommendedState extends Equatable {
  const RecommendedState();

  @override
  List<Object> get props => [];
}

class RecommendedLoading extends RecommendedState {}

class RecommendedLoaded extends RecommendedState {
  final List<User> recommendations;

  const RecommendedLoaded(this.recommendations);

  @override
  List<Object> get props => [recommendations];

  @override
  String toString() {
    return 'RecommendedLoaded { recommendations: $recommendations }';
  }
}

class RecommendedUnavailable extends RecommendedState {}
