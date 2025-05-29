part of "plan_logic.dart";

abstract class PlanEvent {
  const PlanEvent();
}

class PlansFetching extends PlanEvent {}

class PlanFetching extends PlanEvent {
  final int planId;

  const PlanFetching(this.planId);
}
