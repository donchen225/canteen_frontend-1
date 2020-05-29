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

class SearchCompleteShowResults extends SearchState {
  final List<User> results;

  const SearchCompleteShowResults(this.results);

  @override
  List<Object> get props => [results];

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
