// Base state class
abstract class AuthState {}

// --- Login States ---
class LoginInitial extends AuthState {
  final String username;
  final String password;

  LoginInitial(this.username, this.password);
}

class LoginLoading extends AuthState {}

class LoginError extends AuthState {
  final String error;

  LoginError(this.error);
}

class LoginSuccess extends AuthState {
  final String jwt;

  LoginSuccess(this.jwt);
}

// --- Sign-Up with Email States ---
class SignUpWithEmailInitial extends AuthState {
  final String email;
  final String password;
  final String name;

  SignUpWithEmailInitial(this.email, this.password, this.name);
}

class SignUpWithEmailLoading extends AuthState {}

class SignUpWithEmailError extends AuthState {
  final String error;

  SignUpWithEmailError(this.error);
}

class SignUpWithEmailSuccess extends AuthState {
  final String jwt;

  SignUpWithEmailSuccess(this.jwt);
}

// --- Sign-Up with Google States ---
class SignUpWithGoogleInitial extends AuthState {}

class SignUpWithGoogleLoading extends AuthState {}

class SignUpWithGoogleError extends AuthState {
  final String error;

  SignUpWithGoogleError(this.error);
}

class SignUpWithGoogleSuccess extends AuthState {
  final String jwt;

  SignUpWithGoogleSuccess(this.jwt);
}

// --- Forgot Password States ---
class ForgotPasswordInitial extends AuthState {
  final String email;

  ForgotPasswordInitial(this.email);
}

class ForgotPasswordLoading extends AuthState {}

class ForgotPasswordError extends AuthState {
  final String error;

  ForgotPasswordError(this.error);
}

class ForgotPasswordSuccess extends AuthState {
  final String message;

  ForgotPasswordSuccess(this.message);
}
