// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'admin_bloc.dart';

class AdminState {
  final bool isLoading;
  final bool isInitialized;
  final bool redirectToLogin;
  final bool isSuccess;
  final bool hasError;
  final bool isAdding;
  final List<TherapistModel> list;
  final List<TherapistModel> searchResults;
  final bool tokenValid;
  final String message;
  final String searchQuery;
  final File? pickedImage;

  AdminState({
    this.isLoading = false,
    this.isInitialized = false,
    this.redirectToLogin = false,
    this.isSuccess = false,
    this.hasError = false,
    this.isAdding = false,
    this.list = const [],
    this.searchResults = const [],
    this.tokenValid = false,
    this.message = '',
    this.searchQuery = '',
    this.pickedImage,
  });

  AdminState copyWith({
    bool? isLoading,
    bool? isInitialized,
    bool? redirectToLogin,
    bool? isSuccess,
    bool? hasError,
    bool? isAdding,
    List<TherapistModel>? list,
    List<TherapistModel>? searchResults,
    bool? tokenValid,
    String? message,
    String? searchQuery,
    File? pickedImage,
  }) {
    return AdminState(
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      redirectToLogin: redirectToLogin ?? this.redirectToLogin,
      isSuccess: isSuccess ?? this.isSuccess,
      hasError: hasError ?? this.hasError,
      isAdding: isAdding ?? this.isAdding,
      list: list ?? this.list,
      searchResults: searchResults ?? this.searchResults,
      tokenValid: tokenValid ?? this.tokenValid,
      message: message ?? this.message,
      searchQuery: searchQuery ?? this.searchQuery,
      pickedImage: pickedImage ?? this.pickedImage,
    );
  }
}


final class AdminInitial extends AdminState {
  AdminInitial({required super.list});
}