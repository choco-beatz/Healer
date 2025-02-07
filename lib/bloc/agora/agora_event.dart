part of 'agora_bloc.dart';

abstract class AgoraEvent {}

class InitializeAgora extends AgoraEvent {
  final String appId;
  final String therapistId;
  InitializeAgora(this.appId, this.therapistId);
}

class GetToken extends AgoraEvent{}