part of 'login_bloc.dart';

class LoginEvent {}

class LoginActionEvent extends LoginEvent{
  LoginModel data;
  LoginActionEvent({
    required this.data,
  });
}

class CheckTokenEvent extends LoginEvent {}

class LogOutEvent extends LoginEvent {}