part of "plan_logic.dart";

abstract class PlanState {}

class PlanInitial extends PlanState {}

class PlanLoading extends PlanState {}

class PlanError extends PlanState {
  final String message;

  PlanError(this.message);
}

class PlansFetchedSuccess extends PlanState {
  final List<PlanModel> plans;

  PlansFetchedSuccess(this.plans);
}

class PlanUpdatedSuccess extends PlanState {
  final PlanModel updatedPlan;

  PlanUpdatedSuccess(this.updatedPlan);
}

class PlansFetchedError extends PlanState {
  final String message;

  PlansFetchedError(this.message);
}

class PlansFetchedLoading extends PlanState {}

class PlanFetchedSuccess extends PlanState {
  final PlanModel plan;

  PlanFetchedSuccess(this.plan);
}
