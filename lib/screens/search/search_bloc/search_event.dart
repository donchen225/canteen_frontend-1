import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchStarted extends SearchEvent {
  final String query;
  final bool saveQuery;
  final bool fromPreviousSearch;

  const SearchStarted(
      {this.query, this.saveQuery = true, this.fromPreviousSearch = false});

  @override
  List<Object> get props => [query, saveQuery, fromPreviousSearch];

  @override
  String toString() {
    return 'SearchStarted { query: $query, saveQuery: $saveQuery, fromPreviousSearch: $fromPreviousSearch }';
  }
}

class AddQuery extends SearchEvent {
  final String query;

  const AddQuery({this.query});

  @override
  List<Object> get props => [query];

  @override
  String toString() {
    return 'AddQuery';
  }
}

class ShowSearchResults extends SearchEvent {
  final List<User> results;
  final String query;

  const ShowSearchResults({this.results, this.query});

  @override
  List<Object> get props => [results, query];

  @override
  String toString() {
    return 'ShowSearchResults';
  }
}

class ResetSearch extends SearchEvent {}

class ClearSearch extends SearchEvent {}
