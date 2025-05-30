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

class SourceCreatedError extends SourceState {
  final String message;

  SourceCreatedError(this.message);
}

class SourceCreatedSuccess extends SourceState {
  final String sourceId;

  SourceCreatedSuccess(this.sourceId);
}

class SourceDeletedSuccess extends SourceState {
  final String sourceId;

  SourceDeletedSuccess(this.sourceId);
}

class SourceDeletedError extends SourceState {
  final String message;

  SourceDeletedError(this.message);
}
