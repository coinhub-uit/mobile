/// Base event class for authentication-related events.
/// All specific events will extend this abstract class.
abstract class AuthEvent {
  const AuthEvent();
}

/// Navigation event to display the login screen.
class ShowLogin extends AuthEvent {
  const ShowLogin();
}

/// Navigation event to display the sign-up with email screen.
class ShowSignUpWithEmail extends AuthEvent {
  const ShowSignUpWithEmail();
}

/// Navigation event to display the forgot password screen.
class ShowForgotPassword extends AuthEvent {
  const ShowForgotPassword();
}

/// Event to update the username field in the login form.
class LoginUsernameChanged extends AuthEvent {
  final String username;

  const LoginUsernameChanged(this.username);
}

/// Event to update the password field in the login form.
class LoginPasswordChanged extends AuthEvent {
  final String password;

  const LoginPasswordChanged(this.password);
}

/// Event to update the email field in the sign-up with email form.
class SignUpEmailChanged extends AuthEvent {
  final String email;

  const SignUpEmailChanged(this.email);
}

/// Event to update the password field in the sign-up with email form.
class SignUpPasswordChanged extends AuthEvent {
  final String password;

  const SignUpPasswordChanged(this.password);
}

/// Event to update the name field in the sign-up with email form.
class SignUpNameChanged extends AuthEvent {
  final String name;

  const SignUpNameChanged(this.name);
}

/// Event to update the email field in the forgot password form.
class ForgotPasswordEmailChanged extends AuthEvent {
  final String email;

  const ForgotPasswordEmailChanged(this.email);
}

/// Action event to submit the login form.
class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  const LoginSubmitted(this.email, this.password);
}

/// Action event to submit the sign-up with email form.
class SignUpWithEmailSubmitted extends AuthEvent {
  final String email;
  final String password;

  const SignUpWithEmailSubmitted(this.email, this.password);
}

/// Action event to trigger sign-up with Google.
class SignUpWithGooglePressed extends AuthEvent {
  const SignUpWithGooglePressed();
}

/// Action event to submit the forgot password request.
class ForgotPasswordSubmitted extends AuthEvent {
  final String email;
  const ForgotPasswordSubmitted(this.email);
}

class CheckIfVerified extends AuthEvent {
  final String email;
  final String password;
  const CheckIfVerified(this.email, this.password);
}

class ResendVerification extends AuthEvent {
  final String email;
  const ResendVerification(this.email);
}

class ResetPasswordSubmitted extends AuthEvent {
  final String password;

  ResetPasswordSubmitted(this.password);
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

/// Event to update the email field in the sign-up with Google form.
class UpdatePasswordSubmitted extends AuthEvent {
  final String email;
  final String oldPassword;
  final String newPassword;
  const UpdatePasswordSubmitted(this.email, this.oldPassword, this.newPassword);
}
