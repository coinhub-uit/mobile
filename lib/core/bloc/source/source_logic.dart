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
  }
}
