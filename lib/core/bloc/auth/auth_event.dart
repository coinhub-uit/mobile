abstract class LoginEvent {}

class LoginEventLogin extends LoginEvent {
  final String username;
  final String password;

  LoginEventLogin(this.username, this.password);
}

class LoginEventLogout extends LoginEvent {}

class ForgotPasswordEvent extends LoginEvent {
  final String email;

  ForgotPasswordEvent(this.email);
}

class ResetPasswordEvent extends LoginEvent {
  final String password;
  final String token;

  ResetPasswordEvent(this.password, this.token);
}

class OTPEvent extends LoginEvent {
  final String otp;

  OTPEvent(this.otp);
}
