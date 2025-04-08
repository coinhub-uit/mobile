import "package:coinhub/core/bloc/auth/auth_event.dart";
import "package:coinhub/core/bloc/auth/auth_state.dart";
import "package:coinhub/core/services/auth_service.dart";
import "package:coinhub/core/util/email_validator.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:supabase_flutter/supabase_flutter.dart" as supabase;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(LoginInitial("", "")) {
    // Navigation Events
    on<ShowLogin>((event, emit) {
      emit(LoginInitial("", ""));
    });

    on<ShowSignUpWithEmail>((event, emit) {
      emit(SignUpWithEmailInitial("", "", ""));
    });

    on<ShowForgotPassword>((event, emit) {
      emit(ForgotPasswordInitial(""));
    });

    // Form Update Events
    on<LoginUsernameChanged>((event, emit) {
      if (state is LoginInitial) {
        final current = state as LoginInitial;
        emit(LoginInitial(event.username, current.password));
      }
    });

    on<LoginPasswordChanged>((event, emit) {
      if (state is LoginInitial) {
        final current = state as LoginInitial;
        emit(LoginInitial(current.username, event.password));
      }
    });

    on<SignUpEmailChanged>((event, emit) {
      if (state is SignUpWithEmailInitial) {
        final current = state as SignUpWithEmailInitial;
        emit(
          SignUpWithEmailInitial(event.email, current.password, current.name),
        );
      }
    });

    on<SignUpPasswordChanged>((event, emit) {
      if (state is SignUpWithEmailInitial) {
        final current = state as SignUpWithEmailInitial;
        emit(
          SignUpWithEmailInitial(current.email, event.password, current.name),
        );
      }
    });

    on<SignUpNameChanged>((event, emit) {
      if (state is SignUpWithEmailInitial) {
        final current = state as SignUpWithEmailInitial;
        emit(
          SignUpWithEmailInitial(current.email, current.password, event.name),
        );
      }
    });

    on<ForgotPasswordEmailChanged>((event, emit) {
      if (state is ForgotPasswordInitial) {
        emit(ForgotPasswordInitial(event.email));
      }
    });

    // Action Events
    on<LoginSubmitted>((event, emit) async {
      final username = event.email.trim();
      final password = event.password.trim();

      if (username.isEmpty || password.isEmpty) {
        emit(LoginError("Please fill in all fields.", username));
        return;
      }

      if (password.length < 6) {
        emit(
          LoginError("Password must be at least 6 characters long.", username),
        );
        return;
      }

      if (!username.isValidEmail()) {
        emit(LoginError("Please enter a valid email.", username));
        return;
      }

      emit(LoginLoading());

      try {
        final response = await AuthService.signInWithEmailandPassword(
          username,
          password,
        );
        final user = response.user;
        if (response.success == false) {
          emit(
            LoginError(
              "Please check you login credentials and try again.",
              username,
            ),
          );
          return;
        }
        if (user?.emailConfirmedAt == null) {
          emit(
            LoginError("Please verify your email before logging in.", username),
          );
          return;
        }

        emit(LoginSuccess("Login successful."));
      } catch (error) {
        if (error is supabase.AuthException &&
            error.message.contains("Email not confirmed")) {
          emit(
            LoginError(
              "Your email is not verified. Please check your inbox for the verification link.",
              username,
            ),
          );
        } else {
          emit(LoginError(error.toString(), username));
        }
      }
    });

    on<SignUpWithEmailSubmitted>((event, emit) async {
      await AuthService.signOut(); // sign out old user first

      final email = event.email.trim();
      final password = event.password.trim();

      final name = "test";

      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        emit(SignUpWithEmailError("Please fill in all fields."));
        return;
      }

      if (password.length < 6) {
        emit(
          SignUpWithEmailError("Password must be at least 6 characters long."),
        );
        return;
      }

      if (!email.isValidEmail()) {
        emit(SignUpWithEmailError("Please enter a valid email."));
        return;
      }

      emit(SignUpWithEmailLoading());

      try {
        await AuthService.signUpWithEmailandPassword(email, password);
        emit(SignUpWithEmailSuccess(email, password));
      } catch (error) {
        emit(SignUpWithEmailError(error.toString()));
      }
    });

    on<SignUpWithGooglePressed>((event, emit) async {
      emit(SignUpWithGoogleLoading());
      try {
        final user = await AuthService.signInWithGoogle();
        if (user != null) {
          emit(SignUpWithGoogleSuccess("Google sign-in successful."));
        } else {
          emit(SignUpWithGoogleError("Google sign-in failed."));
        }
      } catch (e) {
        emit(SignUpWithGoogleError("An error occurred: $e"));
      }
    });

    on<ForgotPasswordSubmitted>((event, emit) async {
      if (state is ForgotPasswordInitial) {
        final email = event.email.trim();

        if (!email.isValidEmail()) {
          emit(ForgotPasswordError("Please enter a valid email."));
          return;
        }

        emit(ForgotPasswordLoading());

        try {
          await AuthService.forgotPassword(email);
          emit(ForgotPasswordSuccess("Password reset email sent."));
        } catch (error) {
          emit(ForgotPasswordError(error.toString()));
        }
      }
    });

    on<CheckIfVerified>((event, emit) async {
      emit(CheckingIfVerified());
      if (await AuthService.isUserVerified(event.email, event.password)) {
        emit(Verified());
      } else {
        emit(NotVerified());
      }
    });

    on<ResendVerification>((event, emit) async {
      emit(ResendingVerification());
      try {
        await AuthService.resendVerificationCode(event.email);
        emit(ResendVerificationSuccess());
      } catch (error) {
        emit(ResendVerificationError(error.toString()));
      }
    });
    on<ResetPasswordSubmitted>((event, emit) async {
      try {
        final password = event.password.trim();
        if (password.isEmpty) {
          emit(ResetPasswordError("Please enter a new password."));
          return;
        }
        if (password.length < 6) {
          emit(
            ResetPasswordError("Password must be at least 6 characters long."),
          );
          return;
        }
        final response = await AuthService.updatePassword(password);

        if (response.user != null) {
          emit(ResetPasswordSuccess());
        } else if (response.user == null) {
          emit(ResetPasswordError("User not found."));
        } else {
          emit(ResetPasswordError("Unknown error occurred."));
        }
      } catch (e) {
        emit(ResetPasswordError("Exception: ${e.toString()}"));
      }
    });

    on<LogoutEvent>((event, emit) async {
      emit(LoginLoading());
      try {
        await AuthService.signOut();
        emit(LoginInitial("", ""));
      } catch (error) {
        emit(LoginError(error.toString(), ""));
      }
    });

    // update password
    on<UpdatePasswordSubmitted>((event, emit) async {
      emit(UpdatePasswordLoading());
      try {
        if (await AuthService.updatePassword(
          event.email,
          event.oldPassword,
          event.newPassword,
        )) {
          emit(UpdatePasswordSuccess("Password updated successfully."));
        } else {
          emit(UpdatePasswordError("Failed to update password."));
        }
      } catch (error) {
        emit(UpdatePasswordError(error.toString()));
      }
    });
  }
}
