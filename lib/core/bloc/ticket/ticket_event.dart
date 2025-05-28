part of "ticket_logic.dart";

abstract class TicketEvent {
  const TicketEvent();
}

class TicketCreating extends TicketEvent {
  final TicketModel ticket;

  const TicketCreating(this.ticket);
}

class TicketDeleting extends TicketEvent {
  final String ticketId;

  const TicketDeleting(this.ticketId);
}

class TicketFetching extends TicketEvent {
  final String ticketId;

  const TicketFetching(this.ticketId);
}
