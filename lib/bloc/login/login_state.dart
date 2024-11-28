part of 'login_bloc.dart';

class LoginState {
  final String role;
  final bool tokenValid;
  final bool isInitialized;
  final bool redirect;
  final bool hasError;
  final String message;
  
  LoginState(
    {this.tokenValid = false, 
    this.isInitialized = false, 
    this.hasError = false, 
    this.redirect = false,
    this.message = '', 
    this.role = ''});
}

final class LoginInitial extends LoginState {
  LoginInitial({required super.role});
}
