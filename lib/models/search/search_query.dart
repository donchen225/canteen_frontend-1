import 'package:equatable/equatable.dart';

class SearchQuery extends Equatable {
  final String query;
  final String displayQuery;

  SearchQuery({this.query, this.displayQuery});

  @override
  List<Object> get props => [query];
}
