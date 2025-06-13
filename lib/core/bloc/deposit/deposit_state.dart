part of "deposit_logic.dart";

abstract class DepositState {
  const DepositState();
}

class DepositInitial extends DepositState {}

class DepositLoading extends DepositState {}

class DepositError extends DepositState {
  final String message;

  const DepositError(this.message);
}

class DepositTopUpCreated extends DepositState {
  final DepositTopUpResponse response;

  const DepositTopUpCreated(this.response);
}

class DepositStatusChecked extends DepositState {
  final DepositStatusResponse response;

  const DepositStatusChecked(this.response);
}

class DepositSuccess extends DepositState {
  final DepositStatusResponse response;

  const DepositSuccess(this.response);
}

class DepositProcessing extends DepositState {
  final String message;

  const DepositProcessing(this.message);
}
