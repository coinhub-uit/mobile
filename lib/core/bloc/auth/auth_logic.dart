import "package:coinhub/core/bloc/auth/auth_event.dart";
import "package:coinhub/core/bloc/auth/auth_state.dart";
import "package:coinhub/core/services/auth.dart";
import "package:coinhub/core/util/email_validator.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class authBloc extends Bloc<LoginEvent, LoginState> {
  authBloc() : super(LoginStateInitial("", "")) {
    on<LoginEventLogin>((event, emit) {
      final username = event.username;
      final password = event.password;
      if (username.isEmpty || password.isEmpty) {
        emit(LoginStateError("Please fill in all fields."));
      } else if (password.trim().length < 6) {
        emit(LoginStateError("Password must be at least 6 characters long."));
      } else if (!username.trim().isValidEmail()) {
        emit(LoginStateError("Please enter a valid email."));
      } else {
        emit(LoginStateLoading());
        AuthService.signInWithEmailandPassword(username, password)
            .then((value) => emit(LoginStateSuccess("Success")))
            .catchError((error) => emit(LoginStateError(error.toString())));
      }
    });

    on<LoginEventLogout>((event, emit) {
      emit(LoginStateLoading());
      AuthService.signOut()
          .then((value) => emit(LoginStateInitial("", "")))
          .catchError((error) => emit(LoginStateError(error.toString())));
    });

    on<ForgotPasswordEvent>((event, emit) {
      final email = event.email;
      if (!email.trim().isValidEmail()) {
        emit(LoginStateError("Please enter a valid email."));
      } else {
        emit(LoginStateLoading());
        // TODO: Implement forgot password
      }
    });
    on<ResetPasswordEvent>((event, emit) {
      final password = event.password;
      final token = event.token;
      if (password.trim().length < 6) {
        emit(LoginStateError("Password must be at least 6 characters long."));
      } else {
        emit(LoginStateLoading());
        // TODO: Implement reset password
      }
    });
    on<OTPEvent>((event, emit) {
      final otp = event.otp;
      if (otp.trim().length != 6) {
        emit(LoginStateError("OTP must be at least 6 characters long."));
      } else {
        emit(LoginStateLoading());
        // Call the authentication service here
      }
    });
  }
}
