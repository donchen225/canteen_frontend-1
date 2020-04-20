import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class PageTapped extends HomeEvent {
  final int index;

  PageTapped({@required this.index});

  @override
  String toString() => 'PageTapped: $index';
}
