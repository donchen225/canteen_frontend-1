import 'package:equatable/equatable.dart';

abstract class VideoChatDetailsEvent extends Equatable {
  const VideoChatDetailsEvent();

  @override
  List<Object> get props => [];
}

class CheckVideoChatStatus extends VideoChatDetailsEvent {}

class ProposeVideoChatDetails extends VideoChatDetailsEvent {}

class AcceptVideoChatDetails extends VideoChatDetailsEvent {}

class CompleteVideoChat extends VideoChatDetailsEvent {}
