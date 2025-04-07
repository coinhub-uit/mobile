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
  }
}
