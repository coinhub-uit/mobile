import "package:coinhub/core/services/auth_service.dart";
import "package:coinhub/core/services/user_service.dart";
import "package:coinhub/models/source_model.dart";
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
          // final sourceId = event.sourceId;
          // try {
          //   await SourceService.createSource(sourceId);
          // } catch (e) {
          //   // If source does not exist, create it
          //   print("Source not found, creating new source: $sourceId");
          // }
          emit(SignUpDetailsSuccess());
        } else {
          print("Failed to create user: ${response.statusCode}");
          emit(SignUpDetailsError("Failed to create user"));
        }
      } catch (e) {
        print("Error during sign up details submission: $e");
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
          AuthService.deleteUser();
        } else {
          emit(DeleteAccountError("Failed to delete account"));
        }
      } catch (e) {
        emit(DeleteAccountError(e.toString()));
      }
    });
    on<SourceFetching>((event, emit) async {
      emit(SourceLoading());
      try {
        print("Fetching sources for user: ${event.userId}");
        final response = await UserService.fetchSources(event.userId);
        if (response.isNotEmpty) {
          emit(SourceFetchedSuccess(response));
          print("Fetched sources: $response");
        } else {
          emit(SourceFetchedSuccess(response));
        }
      } catch (e) {
        emit(SourceError(e.toString()));
      }
    });
  }
}
