import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class MatchDetailNavigationEvent extends Equatable {
  const MatchDetailNavigationEvent();

  @override
  List<Object> get props => [];
}

class TabTapped extends MatchDetailNavigationEvent {
  final int index;

  TabTapped({@required this.index});

  @override
  String toString() => 'TabTapped: $index';
}

class ClearHome extends MatchDetailNavigationEvent {
  ClearHome();

  @override
  String toString() => 'ClearHome';
}
