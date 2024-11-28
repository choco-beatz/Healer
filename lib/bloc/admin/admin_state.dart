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
  final File? pickedImage;
  AdminState({
     this.list = const [],
    this.isInitialized = false,
    this.isLoading = false,
    this.searchResults = const [],
    this.redirectToLogin = false,
    this.isSuccess = false,
    this.hasError = false,
    this.tokenValid = false,
    this.isAdding = false,
    this.message = "",
    this.pickedImage,
  });
}

final class AdminInitial extends AdminState {
  AdminInitial({required super.list});
}
