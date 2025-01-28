part of 'agora_bloc.dart';

abstract class AgoraEvent {}

class InitializeAgora extends AgoraEvent {
  final String appId;
  final String therapistId;
  InitializeAgora(this.appId, this.therapistId);
}

class JoinVideoCall extends AgoraEvent {
  final String callID;
  final int uid;
  final String token;
  final String callerId;
  JoinVideoCall(
      {required this.callID,
      required this.uid,
      required this.callerId,
      required this.token});
}

class LeaveCall extends AgoraEvent {}

class DisposeAgora extends AgoraEvent {}

class SendCallInvitation extends AgoraEvent {
  final String receiverId;
  final int uid;
  final String callerId;

  SendCallInvitation({
    required this.receiverId,
    required this.uid,
    required this.callerId,
  });
}

class ReceiveCall extends AgoraEvent {
  final String callerId;
  final String channel;

  ReceiveCall({
    required this.callerId,
    required this.channel,
  });
}