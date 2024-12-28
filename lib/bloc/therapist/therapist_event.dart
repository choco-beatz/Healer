part of 'therapist_bloc.dart';

class TherapistEvent {}

class FetchRequestEvent extends TherapistEvent {}

class OnGoingClientEvent extends TherapistEvent {}

class RequestRespondEvent extends TherapistEvent {
  final String requestId;
  final String status;

  RequestRespondEvent({required this.requestId, required this.status});
  
}
