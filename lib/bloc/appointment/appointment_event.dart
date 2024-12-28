part of 'appointment_bloc.dart';

class AppointmentEvent {}

class AddTimeSlotEvent extends AppointmentEvent {
  final String day;
  final String startTime;
  final String endTime;
  final int amount;

  AddTimeSlotEvent(this.day, this.startTime, this.endTime, this.amount);
}

class RemoveTimeSlotEvent extends AppointmentEvent {
  final String day;
  final String startTime;
  final String endTime;

  RemoveTimeSlotEvent(this.day, this.startTime, this.endTime);
}

class ToggleDayActiveEvent extends AppointmentEvent {
  final String day;
  final bool isActive;

  ToggleDayActiveEvent(this.day, this.isActive);
}

class SubmitSlotsEvent extends AppointmentEvent {}

class FetchSlotsEvent extends AppointmentEvent {}

class SlotStatusEvent extends AppointmentEvent {
  final String status;

  SlotStatusEvent({required this.status});
}

class RespondSlotEvent extends AppointmentEvent {
  final String appointmentId;
  final String status;

  RespondSlotEvent({required this.appointmentId, required this.status});
}
