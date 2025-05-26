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

class UpdateDetailsSubmitted extends UserEvent {
  final UserModel userModel;
  const UpdateDetailsSubmitted(this.userModel);
}

class UpdateAvatarSubmitted extends UserEvent {
  final String userId;
  const UpdateAvatarSubmitted(this.userId);
}

class DeleteAccountRequested extends UserEvent {
  final String userId;
  const DeleteAccountRequested(this.userId);
}

class SourceFetching extends UserEvent {
  final String userId;
  const SourceFetching(this.userId);
}
