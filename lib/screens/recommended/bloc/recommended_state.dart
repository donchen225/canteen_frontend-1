import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';

abstract class RecommendedState extends Equatable {
  const RecommendedState();

  @override
  List<Object> get props => [];
}

class RecommendedLoading extends RecommendedState {}

class RecommendedLoaded extends RecommendedState {
  final User user;

  const RecommendedLoaded(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() {
    return 'RecommendedLoaded { user: $user }';
  }
}

class RecommendedEmpty extends RecommendedState {}

class RecommendedUnavailable extends RecommendedState {}
