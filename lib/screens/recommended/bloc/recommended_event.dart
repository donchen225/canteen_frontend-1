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

class NextRecommended extends RecommendedEvent {
  const NextRecommended();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'NextRecommended';
}

class AcceptRecommended extends RecommendedEvent {
  const AcceptRecommended();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'AcceptRecommended';
}
