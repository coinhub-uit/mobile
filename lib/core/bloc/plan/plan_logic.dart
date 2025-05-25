import "package:coinhub/core/services/plan_service.dart";
import "package:coinhub/models/plan_model.dart";
import "package:flutter_bloc/flutter_bloc.dart";

part "plan_event.dart";
part "plan_state.dart";

class PlanBloc extends Bloc<PlanEvent, PlanState> {
  PlanBloc() : super(PlanInitial()) {
    on<PlanFetching>((event, emit) async {
      emit(PlanLoading());
      try {
        final response = await PlanService.fetchPlans();
        if (response.isNotEmpty) {
          emit(PlanFetchedSuccess(response));
          print("Fetched plans: $response");
        } else {
          emit(PlanError("Failed to fetch plan"));
        }
      } catch (e) {
        emit(PlanError(e.toString()));
      }
    });

    // on<PlanUpdated>((event, emit) async {
    //   emit(PlanLoading());
    //   try {
    //     final response = await PlanService.updatePlan(event.planModel);
    //     if (response.statusCode == 200) {
    //       emit(PlanUpdatedSuccess(response.data));
    //     } else {
    //       emit(PlanError("Failed to update plan"));
    //     }
    //   } catch (e) {
    //     emit(PlanError(e.toString()));
    //   }
    // });

    // on<PlanDeleted>((event, emit) async {
    //   emit(PlanLoading());
    //   try {
    //     final response = await PlanService.deletePlan(event.planId);
    //     if (response.statusCode == 200) {
    //       emit(PlanDeletedSuccess(event.planId));
    //     } else {
    //       emit(PlanError("Failed to delete plan"));
    //     }
    //   } catch (e) {
    //     emit(PlanError(e.toString()));
    //   }
    // });
  }
}
