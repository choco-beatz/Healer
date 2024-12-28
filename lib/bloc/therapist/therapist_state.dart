part of 'therapist_bloc.dart';

class TherapistState {
  final List<ClientModel> list;
  final bool isLoading;
  final bool isInitialized;
  final bool isSuccess;
  final bool hasError;
  final int requestCode;
  final Map<String, String> requestStatus;
  final String message;

  TherapistState({
    this.list = const [],
    this.isLoading = false,
    this.isInitialized = false,
    this.requestCode = 0,
    this.isSuccess = false,
    this.hasError = false,
    this.requestStatus = const {},
    this.message = '',
  });

  TherapistState copyWith({
    List<ClientModel>? list,
    bool? isLoading,
    bool? isInitialized,
    bool? isSuccess,
    int? requestCode,
    bool? hasError,
    Set<String>? requestedTherapists,
    Map<String, String>? requestStatus,
    String? message,
  }) {
    return TherapistState(
      requestCode: requestCode ?? this.requestCode,
      list: list ?? this.list,
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      isSuccess: isSuccess ?? this.isSuccess,
      hasError: hasError ?? this.hasError,
      requestStatus: requestStatus ?? this.requestStatus,
      message: message ?? this.message,
    );
  }
}


final class TherapistInitial extends TherapistState {}
