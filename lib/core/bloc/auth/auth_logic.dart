import "package:coinhub/core/bloc/auth/auth_event.dart";
import "package:coinhub/core/bloc/auth/auth_state.dart";
import "package:coinhub/core/services/auth.dart";
import "package:coinhub/core/util/email_validator.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class AuthBloc extends Bloc<LoginEvent, LoginState> {
  AuthBloc() : super(LoginStateInitial("", "")) {
    on<LoginEventLogin>((event, emit) async {
      final email = event.email;
      final password = event.password;

      if (email.isEmpty || password.isEmpty) {
        emit(LoginStateError("Please fill in all fields."));
        return;
      }

      if (password.trim().length < 6) {
        emit(LoginStateError("Password must be at least 6 characters long."));
        return;
      }

      if (!email.trim().isValidEmail()) {
        emit(LoginStateError("Please enter a valid email."));
        return;
      }

      emit(LoginStateLoading());

      try {
        await AuthService.signInWithEmailandPassword(email, password);
        emit(LoginStateSuccess("Success"));
      } catch (error) {
        emit(LoginStateError(error.toString()));
      }
    });

    on<LoginEventGoogle>((event, emit) async {
      emit(LoginStateLoading());

      try {
        final user = await AuthService.signInWithGoogle();

        if (user != null) {
          if (!emit.isDone) emit(LoginStateSuccess("Success"));
        } else {
          if (!emit.isDone) emit(LoginStateError("Google sign-in failed."));
        }
      } catch (e) {
        if (!emit.isDone) emit(LoginStateError("An error occurred: $e"));
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
      // final token = event.token;
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
