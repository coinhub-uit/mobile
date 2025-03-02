abstract class LoginState {}

class LoginStateInitial extends LoginState {
  final String username;
  final String password;

  LoginStateInitial(this.username, this.password);
}

class LoginStateLoading extends LoginState {}

class LoginStateError extends LoginState {
  final String error;

  LoginStateError(this.error);
}

class LoginStateSuccess extends LoginState {
  final String jwt;

  LoginStateSuccess(this.jwt);
}
