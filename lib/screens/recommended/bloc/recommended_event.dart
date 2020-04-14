import 'package:equatable/equatable.dart';

abstract class RecommendedEvent extends Equatable {
  const RecommendedEvent();
}

class LoadRecommended extends RecommendedEvent {
  const LoadRecommended();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'LoadRecommended';
}
