part of "user_logic.dart";

abstract class UserEvent {
  const UserEvent();
}

class SignUpDetailsSubmitted extends UserEvent {
  final UserModel userModel;
  final String userEmail;
  final String userPassword;
  const SignUpDetailsSubmitted(
    this.userModel,
    this.userEmail,
    this.userPassword,
  );
}
