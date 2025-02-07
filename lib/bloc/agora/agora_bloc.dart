import 'package:bloc/bloc.dart';
import 'package:healer_therapist/services/agora/agora_service.dart';
import 'package:healer_therapist/services/agora/constants.dart';

part 'agora_event.dart';
part 'agora_state.dart';

class AgoraBloc extends Bloc<AgoraEvent, AgoraState> {
  final AgoraService _agoraService;

  AgoraBloc(this._agoraService) : super(AgoraInitial()) {
    on<InitializeAgora>(_onInitializeAgora);
    on<GetToken>(_onGetToken);
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

  Future<void> _onGetToken(
    GetToken event,
    Emitter<AgoraState> emit,
  ) async {
    try {
      await _agoraService.fetchAgoraToken();
     
      emit(AgoraLoadedState(
        agoraService: _agoraService, 
        isInitialized: true
      ));
    } catch (error) {
      emit(AgoraErrorState(error.toString()));
    }
  }
 
}
