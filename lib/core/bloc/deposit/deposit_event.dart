part of "deposit_logic.dart";

abstract class DepositEvent {
  const DepositEvent();
}

class DepositCreateTopUp extends DepositEvent {
  final String provider;
  final String returnUrl;
  final double amount;
  final String sourceDestinationId;
  final String ipAddress;

  const DepositCreateTopUp({
    required this.provider,
    required this.returnUrl,
    required this.amount,
    required this.sourceDestinationId,
    required this.ipAddress,
  });
}

class DepositCheckStatus extends DepositEvent {
  final String topUpId;

  const DepositCheckStatus(this.topUpId);
}

class DepositWebViewClosed extends DepositEvent {
  final String topUpId;

  const DepositWebViewClosed(this.topUpId);
}

class DepositCheckStatusDelayed extends DepositEvent {
  final String topUpId;

  const DepositCheckStatusDelayed(this.topUpId);
}
