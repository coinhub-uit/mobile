part of "plan_logic.dart";

abstract class PlanState {}

class PlanInitial extends PlanState {}

class PlanLoading extends PlanState {}

class PlanError extends PlanState {
  final String message;

  PlanError(this.message);
}

class PlanFetchedSuccess extends PlanState {
  final List<PlanModel> plans;

  PlanFetchedSuccess(this.plans);
}

class PlanUpdatedSuccess extends PlanState {
  final PlanModel updatedPlan;

  PlanUpdatedSuccess(this.updatedPlan);
}

class PlanFetchedError extends PlanState {
  final String message;

  PlanFetchedError(this.message);
}

class PlanFetchingLoading extends PlanState {}
