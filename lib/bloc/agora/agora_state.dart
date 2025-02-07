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
