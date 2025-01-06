part of 'agora_bloc.dart';

abstract class AgoraEvent {}

class InitializeAgora extends AgoraEvent {
  final String appId;
  InitializeAgora(this.appId);
}
