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
  final String initialQuery;
  final List<String> searchHistory;

  const SearchTyping({this.initialQuery = '', this.searchHistory});

  @override
  List<Object> get props => [initialQuery, searchHistory];

  @override
  String toString() =>
      'SearchTyping { initialQuery: $initialQuery searchHistory: $searchHistory } ';
}

class SearchCompleteShowResults extends SearchState {
  final String query;
  final List<User> results;

  const SearchCompleteShowResults(this.query, this.results);

  @override
  List<Object> get props => [query, results];

  @override
  String toString() => 'SearchCompleteShowResults';
}

class SearchShowProfile extends SearchState {
  final User user;

  const SearchShowProfile(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'SearchShowProfile';
}

class SearchError extends SearchState {
  const SearchError();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'SearchError';
}
