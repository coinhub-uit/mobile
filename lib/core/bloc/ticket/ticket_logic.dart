import "package:coinhub/core/services/ticket_service.dart";
import "package:coinhub/models/ticket_model.dart";
import "package:flutter_bloc/flutter_bloc.dart";

part "ticket_event.dart";
part "ticket_state.dart";

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  TicketBloc() : super(TicketInitial()) {
    on<TicketCreating>((event, emit) async {
      emit(TicketLoading());
      try {
        final response = await TicketService.createTicket(event.ticket);
        if (response.statusCode == 201) {
          // Assuming the response body contains the created ticket data
          final createdTicket = TicketModel.fromJson(response.body);
          emit(TicketCreatedSuccess(createdTicket));
        } else {
          emit(TicketError("Failed to create ticket: ${response.statusCode}"));
        }
      } catch (e) {
        emit(TicketError("Failed to create ticket: ${e.toString()}"));
      }
    });

    on<TicketDeleting>((event, emit) async {
      emit(TicketLoading());
      try {
        // Simulate a network call to delete a ticket
        await Future.delayed(const Duration(seconds: 2));
        emit(TicketDeletedSuccess(event.ticketId));
      } catch (e) {
        emit(TicketError("Failed to delete ticket: ${e.toString()}"));
      }
    });

    on<TicketFetching>((event, emit) async {
      emit(TicketLoading());
      try {
        final response = await TicketService.fetchTicket(event.ticketId);
        if (response.statusCode == 200) {
          // Assuming the response body contains the ticket data
          final fetchedTicket = TicketModel.fromJson(response.body);
          emit(TicketFetchedSuccess(fetchedTicket));
        } else {
          emit(TicketError("Failed to fetch ticket: ${response.statusCode}"));
        }
      } catch (e) {
        emit(TicketError("Failed to fetch ticket: ${e.toString()}"));
      }
    });
  }
}
