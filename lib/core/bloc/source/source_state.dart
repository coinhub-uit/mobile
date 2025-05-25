part of "source_logic.dart";

abstract class SourceState {
  const SourceState();
}

class SourceInitial extends SourceState {}

class SourceLoading extends SourceState {}

class SourceError extends SourceState {
  final String message;

  SourceError(this.message);
}

class SourceCreatedSuccess extends SourceState {
  final String sourceId;

  SourceCreatedSuccess(this.sourceId);
}
