import 'package:equatable/equatable.dart';

class QueryEntity extends Equatable {
  final String term;
  final DateTime createdOn;

  const QueryEntity(
    this.term,
    this.createdOn,
  );

  @override
  List<Object> get props => [
        term,
        createdOn,
      ];
}
