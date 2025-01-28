import 'package:bloc/bloc.dart';
import 'package:healer_therapist/services/agora/agora_service.dart';
import 'package:healer_therapist/services/agora/constants.dart';

part 'agora_event.dart';
part 'agora_state.dart';

class AgoraBloc extends Bloc<AgoraEvent, AgoraState> {
  final AgoraService _agoraService;

  AgoraBloc(this._agoraService) : super(AgoraInitial()) {
    on<InitializeAgora>(_onInitializeAgora);
    on<JoinVideoCall>(_onJoinVideoCall);
    on<LeaveCall>(_onLeaveCall);
    on<DisposeAgora>(_onDisposeAgora);
    on<ReceiveCall>(_onReceiveCall);
    
  }

  Future<void> _onInitializeAgora(
    InitializeAgora event,
    Emitter<AgoraState> emit,
  ) async {
    try {
      await _agoraService.initializeAgora(appId);
     
      emit(AgoraLoadedState(
        agoraService: _agoraService, 
        isInitialized: true
      ));
    } catch (error) {
      emit(AgoraErrorState(error.toString()));
    }
  }

  Future<void> _onJoinVideoCall(
    JoinVideoCall event,
    Emitter<AgoraState> emit,
  ) async {
    try {
      await _agoraService.joinVideoCall(
        callID: event.callID,
        uid: event.uid,
        token: token,
        onLocalUserJoined: () => emit(VideoCallJoinedState()),
        onUserJoined: (remoteUid) => emit(RemoteUserJoinedState(remoteUid)),
        onUserOffline: (remoteUid) => emit(RemoteUserLeftState(remoteUid)),
      );
    } catch (error) {
      emit(AgoraErrorState(error.toString()));
    }
  }

  Future<void> _onLeaveCall(
    LeaveCall event,
    Emitter<AgoraState> emit,
  ) async {
    try {
      await _agoraService.leaveCall();
      emit(AgoraInitial());
    } catch (error) {
      emit(AgoraErrorState(error.toString()));
    }
  }

  Future<void> _onDisposeAgora(
    DisposeAgora event,
    Emitter<AgoraState> emit,
  ) async {
    await _agoraService.dispose();
    emit(AgoraInitial());
  }

   Future<void> _onReceiveCall(
    ReceiveCall event,
    Emitter<AgoraState> emit,
  ) async {
    emit(CallIncomingState(
      callerId: event.callerId,
      channel: channel,
    ));
  }


  @override
  Future<void> close() {
    _agoraService.dispose();
    return super.close();
  }
}
