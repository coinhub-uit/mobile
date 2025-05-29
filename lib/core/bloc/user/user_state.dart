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

// --- Update Details States ---
class UpdateDetailsInitial extends UserState {}

class UpdateDetailsLoading extends UserState {}

class UpdateDetailsError extends UserState {
  final String error;

  UpdateDetailsError(this.error);
}

class UpdateDetailsSuccess extends UserState {}

// --- update avatar states ---
class UpdateAvatarInitial extends UserState {}

class UpdateAvatarLoading extends UserState {}

class UpdateAvatarError extends UserState {
  final String error;

  UpdateAvatarError(this.error);
}

class UpdateAvatarSuccess extends UserState {
  final String avatarUrl;

  UpdateAvatarSuccess(this.avatarUrl);
}

// --- delete account states ---
class DeleteAccountInitial extends UserState {}

class DeleteAccountLoading extends UserState {}

class DeleteAccountError extends UserState {
  final String error;

  DeleteAccountError(this.error);
}

class DeleteAccountSuccess extends UserState {}

// get sources states
class SourcesFetchedSuccess extends UserState {
  final List<SourceModel> sources;

  SourcesFetchedSuccess(this.sources);
}

class SourcesLoading extends UserState {}

class SourcesError extends UserState {
  final String error;

  SourcesError(this.error);
}

// get tickets states
class TicketFetchedSuccess extends UserState {
  final List<TicketModel> tickets;

  TicketFetchedSuccess(this.tickets);
}

class TicketLoading extends UserState {}

class TicketError extends UserState {
  final String error;

  TicketError(this.error);
}
