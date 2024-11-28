import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:healer_therapist/model/login/login_model.dart';
import 'package:healer_therapist/services/login/login_service.dart';
import 'package:healer_therapist/services/token.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late final StreamSubscription tokenCheck;
  
  LoginBloc() : super(LoginInitial(role: '')) {
       tokenCheck = Stream.periodic(
      const Duration(minutes: 15),
      (_) => CheckTokenEvent(),
    ).listen(
      (event) {
        add(event);
      },
    );
    on<LoginActionEvent>((event, emit) async {
      String role = await login(event.data);
      if (role == 'admin') {
        emit(LoginState(role: 'admin'));
      }
      if (role == 'therapist') {
        emit(LoginState(role: 'therapist'));
      }
    });

    on<CheckTokenEvent>(((event, emit) async {
      log(state.tokenValid.toString());

      if (state.tokenValid && state.isInitialized) return;
      final token = await getValidToken();

      if (token == null || isExpired(token)) {
        emit(LoginState(
            
            hasError: true,
            redirect: true,
            isInitialized: false,
            message: '  Token expired!'));
      } else if (!isExpired(token)) {
        emit(LoginState(
            
            tokenValid: true,
            isInitialized: true));
      } else {
        emit(LoginState(
           
            hasError: true,
            redirect: true,
            isInitialized: false,
            message: '  Token expired!'));
      }
    }));
  }
}
