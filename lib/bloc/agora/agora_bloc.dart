import 'package:bloc/bloc.dart';
import 'package:healer_therapist/services/agora/agora_service.dart';

part 'agora_event.dart';
part 'agora_state.dart';

class AgoraBloc extends Bloc<AgoraEvent, AgoraState> {
  AgoraBloc() : super(AgoraInitial()) {
    // Register the event handler
    on<InitializeAgora>(_onInitializeAgora);
  }

  // Event handler for InitializeAgora
  Future<void> _onInitializeAgora(
    InitializeAgora event,
    Emitter<AgoraState> emit,
  ) async {
    try {
      final agoraService = AgoraService();
      await agoraService.initializeAgora(event.appId);
      emit(AgoraLoadedState(agoraService: agoraService, isInitialized: true));
    } catch (error) {
      emit(AgoraErrorState(error.toString()));
    }
  }
}
