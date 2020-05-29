import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchHome extends SearchEvent {}

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
