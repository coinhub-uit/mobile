part of "user_logic.dart";

abstract class UserState {}

class UserInitial extends UserState {}

// --- Sign-Up Details States ---'
class SignUpDetailsInitial extends UserState {}

class SignUpDetailsLoading extends UserState {}

class SignUpDetailsError extends UserState {
  final String error;

  SignUpDetailsError(this.error);
}

class SignUpDetailsSuccess extends UserState {}
