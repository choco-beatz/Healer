import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:healer_therapist/model/appointment/appointment_model.dart';
import 'package:healer_therapist/services/therapist/appointment_service.dart';
import 'package:intl/intl.dart';

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
    emit(AppointmentLoadingState());

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

      emit(AppointmentLoadedState(
        weeklySlots: weeklySlots,
        isActiveDays: isActiveDays,
      ));
    } catch (e) {
      log('Error fetching slots: $e');
      emit(AppointmentErrorState('Failed to fetch slots.'));
    }
  }

  void _onAddTimeSlotEvent(
      AddTimeSlotEvent event, Emitter<AppointmentState> emit) {
    final updatedSlots =
        state.weeklySlots.map<String, List<Map<String, dynamic>>>(
      (key, value) => MapEntry(
        key,
        value
            .map<Map<String, dynamic>>(
                (item) => Map<String, dynamic>.from(item))
            .toList(),
      ),
    );

    if (!updatedSlots.containsKey(event.day)) {
      updatedSlots[event.day] = [];
    }

    updatedSlots[event.day]!.add({
      'startTime': event.startTime,
      'endTime': event.endTime,
      'amount': event.amount,
    });

    emit(AppointmentState(
      weeklySlots: updatedSlots,
      isActiveDays: state.isActiveDays,
      hasChanges: true,
    ));
  }

  void _onRemoveTimeSlotEvent(
      RemoveTimeSlotEvent event, Emitter<AppointmentState> emit) {
    final updatedSlots =
        Map<String, List<Map<String, dynamic>>>.from(state.weeklySlots);

    if (updatedSlots.containsKey(event.day)) {
      updatedSlots[event.day] =
          List<Map<String, dynamic>>.from(updatedSlots[event.day]!);

      final timeFormatter = DateFormat("hh:mm a");
      final formattedEventStartTime =
          timeFormatter.format(timeFormatter.parse(event.startTime));
      final formattedEventEndTime =
          timeFormatter.format(timeFormatter.parse(event.endTime));

      updatedSlots[event.day]!.removeWhere((slot) {
        final formattedSlotStartTime =
            timeFormatter.format(timeFormatter.parse(slot['startTime']));
        final formattedSlotEndTime =
            timeFormatter.format(timeFormatter.parse(slot['endTime']));
        return formattedSlotStartTime == formattedEventStartTime &&
            formattedSlotEndTime == formattedEventEndTime;
      });

      if (updatedSlots[event.day]!.isEmpty) {
        updatedSlots[event.day] = [];
      }

      emit(AppointmentState(
        weeklySlots: updatedSlots,
        hasChanges: true,
      ));
    }
  }

  void _onSlotStatusEvent(
      SlotStatusEvent event, Emitter<AppointmentState> emit) async {
    try {
      List<AppointmentModel> list = await slotStatus(event.status);
      log(list.toString());
      emit(AppointmentState(
        appointments: list,
        isLoading: false,
      ));
    } catch (e) {
      log(e.toString());
      emit(AppointmentState(
        isLoading: false,
        hasError: true,
      ));
    }
  }

  void _onRespondSlotEvent(
      RespondSlotEvent event, Emitter<AppointmentState> emit) async {
    try {
      bool success = await respondSlots(event.appointmentId, event.status);

      emit(AppointmentState(
        isSuccess: success,
        responseStatus: success ? 'success' : 'error',
        isLoading: false,
      ));
    } catch (e) {
      log(e.toString());
      emit(AppointmentState(
        isLoading: false,
        isSuccess: false,
        hasError: true,
      ));
    }
  }

  void _onToggleDayActiveEvent(
      ToggleDayActiveEvent event, Emitter<AppointmentState> emit) {
    final updatedActiveDays = Map<String, bool>.from(state.isActiveDays);
    updatedActiveDays[event.day] = event.isActive;

    emit(AppointmentState(
      weeklySlots: state.weeklySlots,
      isActiveDays: updatedActiveDays,
      hasChanges: true,
    ));
  }

  void _onSubmitSlotsEvent(
      SubmitSlotsEvent event, Emitter<AppointmentState> emit) async {
    emit(AppointmentState(
      weeklySlots: state.weeklySlots,
      isActiveDays: state.isActiveDays,
      hasChanges: state.hasChanges,
      isSubmitting: true,
    ));

    try {
      final filteredSlots = state.weeklySlots.entries
          .map((entry) => {
                "day": entry.key,
                "isActive": state.isActiveDays[entry.key] ?? false,
                "timeSlots": entry.value
                    .map((slot) => {
                          "startTime": slot["startTime"],
                          "endTime": slot["endTime"],
                          "amount": slot["amount"],
                        })
                    .toList(),
              })
          .where((daySlot) =>
              daySlot["isActive"] == true ||
              (daySlot["timeSlots"] as List).isNotEmpty)
          .toList();

      final payload = {"slots": filteredSlots};
      final success = await updateSlots(payload);

      if (success == true) {
        emit(AppointmentState(
          weeklySlots: state.weeklySlots,
          isActiveDays: state.isActiveDays,
          hasChanges: false,
          isSubmitting: false,
          isSuccess: true,
        ));
      }
    } catch (error) {
      log("Response Error: $error");
      emit(AppointmentState(
        weeklySlots: state.weeklySlots,
        isActiveDays: state.isActiveDays,
        hasChanges: state.hasChanges,
        isSubmitting: false,
        isSuccess: false,
      ));
    }
  }
}
