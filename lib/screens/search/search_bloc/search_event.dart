import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchHome extends SearchEvent {}

class EnterSearchQuery extends SearchEvent {
  final String initialQuery;

  const EnterSearchQuery({this.initialQuery = ''});

  @override
  List<Object> get props => [initialQuery];

  @override
  String toString() {
    return 'EnterSearchQuery { initialQuery: $initialQuery }';
  }
}

class SearchStarted extends SearchEvent {
  final String query;

  const SearchStarted(this.query);

  @override
  List<Object> get props => [query];

  @override
  String toString() {
    return 'SearchStarted { query: $query }';
  }
}

class SearchShowResults extends SearchEvent {}

class SearchInspectUser extends SearchEvent {
  final User user;

  const SearchInspectUser(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() {
    return 'SearchInspectUser { user: ${user.id}, ${user.displayName} }';
  }
}
