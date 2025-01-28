part of 'therapist_bloc.dart';

abstract class TherapistState {}

class TherapistInitial extends TherapistState {}

class ClientLoading extends TherapistState {}

class ClientLoaded extends TherapistState {
  final List<RequestModel> list;
  ClientLoaded({required this.list});
}

class ClientError extends TherapistState {
  final String message;
  ClientError({required this.message});
}

class TherapistProfileLoading extends TherapistState {}

class TherapistProfileLoaded extends TherapistState {
  final UserModel therapist;
  TherapistProfileLoaded({required this.therapist});
}

class TherapistProfileError extends TherapistState {
  final String message;
  TherapistProfileError({required this.message});
}

class TherapistRequestStatusUpdated extends TherapistState {
  final Map<String, String> requestStatus;
  TherapistRequestStatusUpdated({required this.requestStatus});
}
