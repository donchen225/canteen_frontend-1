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

class SearchCompleteWithResults extends SearchState {
  final List<User> userList;

  const SearchCompleteWithResults(this.userList);

  @override
  List<Object> get props => [userList];

  @override
  String toString() => 'SearchCompleteWithResults';
}

class SearchCompleteNoResults extends SearchState {
  const SearchCompleteNoResults();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'SearchCompleteNoResults { }';
}

class SearchShowProfile extends SearchState {
  final User user;
  final bool isSearchResult;

  const SearchShowProfile(this.user, this.isSearchResult);

  @override
  List<Object> get props => [user, isSearchResult];

  @override
  String toString() =>
      'SearchShowProfile { user: ${user.id}, ${user.displayName} isSearchResult: $isSearchResult }';
}

class SearchResultsEnd extends SearchState {
  const SearchResultsEnd();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'SearchResultsEnd { }';
}
