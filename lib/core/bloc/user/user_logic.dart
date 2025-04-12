import "package:coinhub/core/services/user_service.dart";
import "package:coinhub/models/user_model.dart";
import "package:flutter_bloc/flutter_bloc.dart";

part "user_event.dart";
part "user_state.dart";

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<SignUpDetailsSubmitted>((event, emit) async {
      emit(SignUpDetailsLoading());
      try {
        final response = await UserService.signUpDetails(
          event.userModel,
          event.userEmail,
          event.userPassword,
        );
        if (response.statusCode == 201) {
          emit(SignUpDetailsSuccess());
        } else {
          emit(SignUpDetailsError("Failed to create user"));
        }
      } catch (e) {
        emit(SignUpDetailsError(e.toString()));
      }
    });
    on<UpdateDetailsSubmitted>((event, emit) async {
      emit(UpdateDetailsLoading());
      try {
        final response = await UserService.updateUserDetails(event.userModel);
        if (response.statusCode == 200) {
          emit(UpdateDetailsSuccess());
        } else {
          emit(UpdateDetailsError("Failed to update user details"));
        }
      } catch (e) {
        emit(UpdateDetailsError(e.toString()));
      }
    });
    on<UpdateAvatarSubmitted>((event, emit) async {
      emit(UpdateAvatarLoading());
      try {
        final avatarUrl = await UserService.pickAndUploadAvatar(event.userId);
        emit(UpdateAvatarSuccess(avatarUrl));
      } catch (e) {
        emit(UpdateAvatarError(e.toString()));
      }
    });
    on<DeleteAccountRequested>((event, emit) async {
      emit(DeleteAccountLoading());
      try {
        final response = await UserService.deleteUserAccount(event.userId);
        if (response.statusCode == 200) {
          emit(DeleteAccountSuccess());
        } else {
          emit(DeleteAccountError("Failed to delete account"));
        }
      } catch (e) {
        emit(DeleteAccountError(e.toString()));
      }
    });
  }
}
