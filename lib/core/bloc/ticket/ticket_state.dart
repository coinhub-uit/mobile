part of "ticket_logic.dart";

abstract class TicketState {
  const TicketState();
}

class TicketInitial extends TicketState {
  const TicketInitial();
}

class TicketLoading extends TicketState {
  const TicketLoading();
}

class TicketCreatedSuccess extends TicketState {
  final TicketModel ticket; // Replace 'dynamic' with the actual type if known

  const TicketCreatedSuccess(this.ticket);
}

class TicketDeletedSuccess extends TicketState {
  final String ticketId;

  const TicketDeletedSuccess(this.ticketId);
}

class TicketError extends TicketState {
  final String message;

  const TicketError(this.message);
}

class TicketFetchedSuccess extends TicketState {
  final TicketModel ticket; // Replace 'dynamic' with the actual type if known

  const TicketFetchedSuccess(this.ticket);
}
