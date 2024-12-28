part of 'appointment_bloc.dart';

class AppointmentState {
  final Map<String, List<Map<String, dynamic>>> weeklySlots;
  final bool hasChanges;
  final List<AppointmentModel> appointments;
  final Map<String, bool> isActiveDays;
  final bool isSubmitting;
  final bool isLoading;
  final bool hasError;
  final String responseStatus;
  final bool isSuccess;

  AppointmentState({
    this.weeklySlots = const {
      "Monday": [],
      "Tuesday": [],
      "Wednesday": [],
      "Thursday": [],
      "Friday": [],
      "Saturday": [],
      "Sunday": [],
    },
    this.hasChanges = false,
    this.appointments = const [],
    this.isSubmitting = false,
    this.hasError = false,
    this.responseStatus = '',
    this.isLoading = false,
    this.isSuccess = false,
    this.isActiveDays = const {
      "Monday": false,
      "Tuesday": false,
      "Wednesday": false,
      "Thursday": false,
      "Friday": false,
      "Saturday": false,
      "Sunday": false,
    },
  });

  AppointmentState copyWith({
    Map<String, List<Map<String, dynamic>>>? weeklySlots,
    bool? hasChanges,
    bool? isSubmitting,
    List<AppointmentModel>? appointments,
    bool? isLoading,
    bool? hasError,
    String? responseStatus,
    bool? isSuccess,
    Map<String, bool>? isActiveDays,
  }) {
    return AppointmentState(
      weeklySlots: weeklySlots ?? this.weeklySlots,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      hasChanges: hasChanges ?? this.hasChanges,
      hasError: hasError ?? this.hasError,
      responseStatus: responseStatus ?? this.responseStatus,
      isLoading: isLoading ?? this.isLoading,
      appointments: appointments ?? this.appointments,
      isSuccess: isSuccess ?? this.isSuccess,
      isActiveDays: isActiveDays ?? this.isActiveDays,
    );
  }
}

class AppointmentLoadingState extends AppointmentState {}

class AppointmentLoadedState extends AppointmentState {
  final Map<String, List<Map<String, dynamic>>> weeklySlots;
  final Map<String, bool> isActiveDays;

  AppointmentLoadedState({
    required this.weeklySlots,
    required this.isActiveDays,
  });
}

class AppointmentErrorState extends AppointmentState {
  final String message;

  AppointmentErrorState(this.message);
}

final class AppointmentInitial extends AppointmentState {}
