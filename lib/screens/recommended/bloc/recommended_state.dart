import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';

abstract class RecommendedState extends Equatable {
  const RecommendedState();

  @override
  List<Object> get props => [];
}

class RecommendedLoading extends RecommendedState {}

class RecommendedLoaded extends RecommendedState {
  final List<User> userList;

  const RecommendedLoaded(this.userList);

  @override
  List<Object> get props => [userList];

  @override
  String toString() {
    return 'RecommendedLoaded { userList: $userList }';
  }
}

class RecommendedEmpty extends RecommendedState {}
