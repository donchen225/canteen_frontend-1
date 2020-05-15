import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchUninitialized extends SearchState {
  final List<User> allUsers;

  const SearchUninitialized(this.allUsers);

  @override
  List<Object> get props => [allUsers];

  @override
  String toString() => 'SearchUninitialized';
}

class SearchLoading extends SearchState {}

class SearchTyping extends SearchState {
  final List<String> searchHistory;

  const SearchTyping(this.searchHistory);

  @override
  List<Object> get props => [searchHistory];

  @override
  String toString() => 'SearchTyping';
}

class SearchCompleteShowResults extends SearchState {
  final List<User> userList;

  const SearchCompleteShowResults(this.userList);

  @override
  List<Object> get props => [userList];

  @override
  String toString() => 'SearchCompleteShowResults';
}

class SearchError extends SearchState {
  const SearchError();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'SearchError';
}
