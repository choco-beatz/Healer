part of 'agora_bloc.dart';

abstract class AgoraState {}
class AgoraInitial extends AgoraState {}
class AgoraLoadedState extends AgoraState {
  final AgoraService agoraService;
  final bool isInitialized;
  AgoraLoadedState({
    required this.agoraService, 
    required this.isInitialized
  });
}
class AgoraErrorState extends AgoraState {
  final String error;
  AgoraErrorState(this.error);
}
class VideoCallJoinedState extends AgoraState {}
class RemoteUserJoinedState extends AgoraState {
  final int remoteUid;
  RemoteUserJoinedState(this.remoteUid);
}
class RemoteUserLeftState extends AgoraState {
  final int remoteUid;
  RemoteUserLeftState(this.remoteUid);
}

class CallInvitationSentState extends AgoraState {
  final String receiverId;

  CallInvitationSentState({required this.receiverId});
}

class CallInvitationReceivedState extends AgoraState {
  final String callID;
  final String callerId;

  CallInvitationReceivedState({
    required this.callID,
    required this.callerId,
  });
}


class CallIncomingState extends AgoraState {
  final String callerId;
  final String channel;

  CallIncomingState({
    required this.callerId,
    required this.channel,
  });
}