import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchReset extends SearchState {}

class SearchLoading extends SearchState {}

class SearchCompleteWithResults extends SearchState {
  final List<User> userList;

  const SearchCompleteWithResults(this.userList);

  @override
  List<Object> get props => [userList];

  @override
  String toString() => 'SearchCompleteWithResults { ${userList.toString()} }';
}

class SearchCompleteNoResults extends SearchState {
  final String message;

  const SearchCompleteNoResults(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'SearchCompleteNoResults { message: $message }';
}

class SearchShowProfile extends SearchState {
  final User user;

  const SearchShowProfile(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'SearchShowProfile { user: $user }';
}
