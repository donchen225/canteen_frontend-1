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

class ResetSearch extends SearchEvent {}

class ClearSearch extends SearchEvent {}
