import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:healer_therapist/model/appointment/appointment_model.dart';
import 'package:healer_therapist/services/therapist/appointment_service.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  AppointmentBloc() : super(AppointmentInitial()) {
    on<AddTimeSlotEvent>(_onAddTimeSlotEvent);
    on<SlotStatusEvent>(_onSlotStatusEvent);
    on<RemoveTimeSlotEvent>(_onRemoveTimeSlotEvent);
    on<ToggleDayActiveEvent>(_onToggleDayActiveEvent);
    on<SubmitSlotsEvent>(_onSubmitSlotsEvent);
    on<FetchSlotsEvent>(_onFetchSlotsEvent);
    on<RespondSlotEvent>(_onRespondSlotEvent);
  }

  Future<void> _onFetchSlotsEvent(
      FetchSlotsEvent event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      final appointments = await fetchSlots();

      final weeklySlots = <String, List<Map<String, dynamic>>>{};
      final isActiveDays = <String, bool>{};

      for (var appointment in appointments) {
        weeklySlots[appointment.day] = appointment.timeSlots
            .map((slot) => {
                  'startTime': slot.startTime,
                  'endTime': slot.endTime,
                  'amount': slot.amount,
                })
            .toList();
        isActiveDays[appointment.day] = appointment.isActive;
      }

      emit(AppointmentLoaded(
        weeklySlots: weeklySlots,
        isActiveDays: isActiveDays,
      ));
    } catch (e) {
      log('error');
    }
  }

  void _onSlotStatusEvent(
      SlotStatusEvent event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading()); // Emit loading state first

    try {
      final List<AppointmentModel> list = await slotStatus(event.status);
      emit(AppointmentSuccessState(
        hasChanges: false,
        appointments: list,
        responseStatus: 'success', // Add responseStatus
      ));
    } catch (e) {
      log(e.toString());
      emit(AppointmentError(
        message: 'Failed to fetch slot status.',
      ));
    }
  }

  void _onAddTimeSlotEvent(
      AddTimeSlotEvent event, Emitter<AppointmentState> emit) {
    if (state is AppointmentLoaded) {
      final currentState = state as AppointmentLoaded;

      final updatedSlots = Map<String, List<Map<String, dynamic>>>.from(
          currentState.weeklySlots);

      if (!updatedSlots.containsKey(event.day)) {
        updatedSlots[event.day] = [];
      }

      updatedSlots[event.day]!.add({
        'startTime': event.startTime,
        'endTime': event.endTime,
        'amount': event.amount,
      });

      emit(AppointmentLoaded(
        weeklySlots: updatedSlots,
        isActiveDays: currentState.isActiveDays,
        hasChanges: true,
      ));
    }
  }

  void _onRemoveTimeSlotEvent(
      RemoveTimeSlotEvent event, Emitter<AppointmentState> emit) {
    if (state is AppointmentLoaded) {
      final currentState = state as AppointmentLoaded;

      final updatedSlots = Map<String, List<Map<String, dynamic>>>.from(
          currentState.weeklySlots);

      if (updatedSlots.containsKey(event.day)) {
        updatedSlots[event.day] =
            List<Map<String, dynamic>>.from(updatedSlots[event.day]!);

        updatedSlots[event.day]!.removeWhere((slot) =>
            slot['startTime'] == event.startTime &&
            slot['endTime'] == event.endTime);

        emit(AppointmentLoaded(
          weeklySlots: updatedSlots,
          isActiveDays: currentState.isActiveDays,
          hasChanges: true,
        ));
      }
    }
  }

  void _onToggleDayActiveEvent(
      ToggleDayActiveEvent event, Emitter<AppointmentState> emit) {
    if (state is AppointmentLoaded) {
      final currentState = state as AppointmentLoaded;

      final updatedActiveDays =
          Map<String, bool>.from(currentState.isActiveDays);
      updatedActiveDays[event.day] = event.isActive;

      emit(AppointmentLoaded(
        weeklySlots: currentState.weeklySlots,
        isActiveDays: updatedActiveDays,
        hasChanges: true,
      ));
    }
  }

  Future<void> _onSubmitSlotsEvent(
      SubmitSlotsEvent event, Emitter<AppointmentState> emit) async {
    if (state is AppointmentLoaded) {
      final currentState = state as AppointmentLoaded;

      emit(AppointmentSubmitting(
        weeklySlots: currentState.weeklySlots,
        isActiveDays: currentState.isActiveDays,
      ));

      try {
        // Validate slots
        final validatedSlots = currentState.weeklySlots.entries.map((entry) {
          final day = entry.key;
          final timeSlots = entry.value;
          final isActive = currentState.isActiveDays[day] ?? false;

          // Ensure non-empty timeSlots if the day is active
          if (isActive && timeSlots.isEmpty) {
            throw Exception("Day '$day' is active but has no time slots.");
          }

          return {
            "day": day,
            "isActive": isActive,
            "timeSlots": timeSlots,
          };
        }).toList();

        final payload = {"slots": validatedSlots};

        final success = await updateSlots(payload);

        if (success) {
          emit(AppointmentSuccess(message: 'Slots submitted successfully.'));
          add(FetchSlotsEvent());
        } else {
          emit(AppointmentFailure(error: 'Failed to submit slots.'));
        }
      } catch (error) {
        emit(AppointmentFailure(error: error.toString()));
      }
    }
  }

  Future<void> _onRespondSlotEvent(
      RespondSlotEvent event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());

    try {
      final success = await respondSlots(event.appointmentId, event.status);

      if (success) {
        emit(AppointmentSuccess(
          message: 'Response submitted successfully.',
        ));
      } else {
        emit(AppointmentFailure(
          error: 'Failed to submit response.',
        ));
      }
    } catch (e) {
      log(e.toString());
      emit(AppointmentError(
        message: 'An unexpected error occurred.',
      ));
    }
  }
}
