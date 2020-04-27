import 'package:equatable/equatable.dart';

abstract class MatchDetailState extends Equatable {
  const MatchDetailState();

  @override
  List<Object> get props => [];
}

// Screen to select initial time
class MatchUninitialized extends MatchDetailState {}

class MatchLoading extends MatchDetailState {}

// Initial time has been selected, requires user payment
class MatchUnpaid extends MatchDetailState {}

// Initial time and payment have been completed
class MatchInitialized extends MatchDetailState {}

class MatchConfirmed extends MatchDetailState {}

class MatchCompleted extends MatchDetailState {}
