part of 'appointment_bloc.dart';

abstract class AppointmentState {
  final String? responseStatus;

  AppointmentState({this.responseStatus});
}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentLoaded extends AppointmentState {
  final Map<String, List<Map<String, dynamic>>> weeklySlots;
  final Map<String, bool> isActiveDays;
  final bool hasChanges;

  AppointmentLoaded({
    required this.weeklySlots,
    required this.isActiveDays,
    this.hasChanges = false,
    super.responseStatus,
  });
}

class AppointmentError extends AppointmentState {
  final String message;

  AppointmentError({required this.message});
}

class AppointmentSubmitting extends AppointmentState {
  final Map<String, List<Map<String, dynamic>>> weeklySlots;
  final Map<String, bool> isActiveDays;

  AppointmentSubmitting({
    required this.weeklySlots,
    required this.isActiveDays,
    super.responseStatus
  });
}

class AppointmentSuccess extends AppointmentState {
  final String message;

  AppointmentSuccess({required this.message})
      : super(responseStatus: 'success');
}

class AppointmentFailure extends AppointmentState {
  final String error;

  AppointmentFailure({required this.error})
      : super(responseStatus: 'error');
}

class AppointmentSuccessState extends AppointmentState {
  final List<AppointmentModel> appointments;
  final bool hasChanges;

  AppointmentSuccessState({
    required this.appointments,
    String? responseStatus,
    required this.hasChanges,
  }) : super(responseStatus: responseStatus ?? 'success');
}
