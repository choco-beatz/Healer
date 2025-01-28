import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:healer_therapist/model/client/client_model.dart';
import 'package:healer_therapist/model/profile/profile_model.dart';
import 'package:healer_therapist/services/therapist/client_service.dart';
import 'package:healer_therapist/services/therapist/profile_service.dart';

part 'therapist_event.dart';
part 'therapist_state.dart';

class TherapistBloc extends Bloc<TherapistEvent, TherapistState> {
  TherapistBloc() : super(TherapistInitial()) {
    on<FetchRequestEvent>((event, emit) async {
      emit(ClientLoading());
      try {
        final clients = await fetchRequest();
        emit(ClientLoaded(list: clients));
      } catch (e) {
        log('FetchRequestEvent Error: $e');
        emit(ClientError(message: 'Failed to fetch therapists.'));
      }
    });

    on<OnGoingClientEvent>((event, emit) async {
      emit(ClientLoading());
      try {
        final clients = await onGoingClient();
        emit(ClientLoaded(list: clients));
      } catch (e) {
        log('OnGoingClientEvent Error: $e');
        emit(ClientError(message: 'Failed to fetch ongoing clients.'));
      }
    });

    on<GetProfileEvent>((event, emit) async {
      emit(TherapistProfileLoading());
      try {
        final user = await getProfile();
        if (user != null) {
          emit(TherapistProfileLoaded(therapist: user));
        } else {
          emit(TherapistProfileError(message: 'User profile not found.'));
        }
      } catch (e) {
        log('GetProfileEvent Error: $e');
        emit(TherapistProfileError(message: 'Failed to load profile.'));
      }
    });

    on<RequestRespondEvent>((event, emit) async {
      emit(ClientLoading());
      try {
        final success = await requestRespond(event.requestId, event.status);
        if (success) {
          final updatedStatus = Map<String, String>.from(state is ClientLoaded
              ? (state as ClientLoaded).list.asMap().map((key, value) => MapEntry(value.id, event.status))
              : {});
          emit(TherapistRequestStatusUpdated(requestStatus: updatedStatus));
        } else {
          emit(ClientError(message: 'Failed to update request status.'));
        }
      } catch (e) {
        log('RequestRespondEvent Error: $e');
        emit(ClientError(message: 'An error occurred while responding.'));
      }
    });
  }
}
