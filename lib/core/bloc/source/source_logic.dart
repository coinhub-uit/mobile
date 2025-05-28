import "package:coinhub/core/services/source_service.dart";
import "package:flutter_bloc/flutter_bloc.dart";

part "source_event.dart";
part "source_state.dart";

class SourceBloc extends Bloc<SourceEvent, SourceState> {
  SourceBloc() : super(SourceInitial()) {
    // on<SourceFetching>((event, emit) async {
    //   emit(SourceLoading());
    //   try {
    //     final response = await SourceService.fetchSources(event.userId);
    //     if (response.isNotEmpty) {
    //       emit(SourceFetchedSuccess(response));
    //       print("Fetched sources: $response");
    //     } else {
    //       emit(SourceError("Failed to fetch sources"));
    //     }
    //   } catch (e) {
    //     emit(SourceError(e.toString()));
    //   }
    // });
    on<SourceCreating>((event, emit) async {
      emit(SourceLoading());
      try {
        final response = await SourceService.createSource(event.sourceId);
        if (response.statusCode == 201) {
          emit(SourceCreatedSuccess(response.body));
        } else {
          emit(SourceError("Failed to create source"));
        }
      } catch (e) {
        emit(SourceError(e.toString()));
      }
    });

    on<SourceDeleting>((event, emit) async {
      emit(SourceLoading());
      try {
        final response = await SourceService.deleteSource(event.sourceId);
        if (response.statusCode == 200) {
          emit(SourceDeletedSuccess(event.sourceId));
        } else if (response.statusCode == 409) {
          emit(
            SourceError(
              "Please make sure the source does not have any money in it.",
            ),
          );
        } else {
          emit(SourceError("Please make sure the source is not in use."));
        }
      } catch (e) {
        emit(SourceError(e.toString()));
      }
    });
  }
}
