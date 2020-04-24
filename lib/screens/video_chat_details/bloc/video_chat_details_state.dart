import 'package:equatable/equatable.dart';

abstract class VideoChatDetailsState extends Equatable {
  const VideoChatDetailsState();

  @override
  List<Object> get props => [];
}

class VideoChatDetailsLoading extends VideoChatDetailsState {}

class VideoChatDetailsUninitialized extends VideoChatDetailsState {}

class VideoChatDetailsProposing extends VideoChatDetailsState {}

class VideoChatDetailsAccepted extends VideoChatDetailsState {}

class VideoChatCompleted extends VideoChatDetailsState {}
