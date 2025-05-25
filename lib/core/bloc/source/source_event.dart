part of "source_logic.dart";

abstract class SourceEvent {
  const SourceEvent();
}

// class SourceFetching extends SourceEvent {
//   final String userId;

//   const SourceFetching(this.userId);
// }

class SourceCreating extends SourceEvent {
  final String sourceId;

  const SourceCreating(this.sourceId);
}
