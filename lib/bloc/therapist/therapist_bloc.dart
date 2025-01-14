import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:healer_therapist/model/client/client_model.dart';
import 'package:healer_therapist/services/therapist/client_service.dart';

part 'therapist_event.dart';
part 'therapist_state.dart';

class TherapistBloc extends Bloc<TherapistEvent, TherapistState> {
  TherapistBloc() : super(TherapistInitial()) {
    on<FetchRequestEvent>((event, emit) async {
      // if (state.isInitialized && state.list.isNotEmpty) {
      //   log('FetchRequestEvent skipped: Data already initialized');
      //   return;
      // }

      try {
        emit(state.copyWith(isLoading: true));
        final clients = await fetchRequest();
        emit(state.copyWith(
          list: clients,
          isLoading: false,
          isInitialized: true,
        ));
      } catch (e) {
        log(e.toString());
        emit(state.copyWith(
          isLoading: false,
          hasError: true,
          message: e.toString(),
        ));
      }
    });

    on<OnGoingClientEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, hasError: false, message: ''));
      try {
        final clients = await onGoingClient();
        emit(state.copyWith(
          list: clients,
          isLoading: false,
          isInitialized: true,
          hasError: false,
        ));
      } catch (e) {
        log(e.toString());
        emit(state.copyWith(
          isLoading: false,
          hasError: true,
          message: e.toString(),
        ));
      }
    });

    on<RequestRespondEvent>((event, emit) async {
      if (state.isLoading) return;

      try {
        final success = await requestRespond(event.requestId, event.status);
        final updatedStatus = Map<String, String>.from(state.requestStatus);
        updatedStatus[event.requestId] = event.status;
        emit(state.copyWith(
            isSuccess: success,
            isLoading: false,
            isInitialized: true,
            requestStatus: updatedStatus));
      } catch (e) {
        log(e.toString());
        emit(state.copyWith(
          isLoading: false,
          isSuccess: false,
          hasError: true,
          message: e.toString(),
        ));
      }
    });
  }
}
