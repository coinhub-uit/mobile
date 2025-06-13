import "package:coinhub/core/services/deposit_service.dart";
import "package:coinhub/models/deposit_model.dart";
import "package:flutter_bloc/flutter_bloc.dart";

part "deposit_event.dart";
part "deposit_state.dart";

class DepositBloc extends Bloc<DepositEvent, DepositState> {
  DepositBloc() : super(DepositInitial()) {
    on<DepositCreateTopUp>((event, emit) async {
      emit(DepositLoading());
      try {
        final response = await DepositService.createTopUp(
          provider: event.provider,
          returnUrl: event.returnUrl,
          amount: event.amount,
          sourceDestinationId: event.sourceDestinationId,
          ipAddress: event.ipAddress,
        );
        emit(DepositTopUpCreated(response));
      } catch (e) {
        emit(DepositError("Failed to create top-up: ${e.toString()}"));
      }
    });

    on<DepositCheckStatus>((event, emit) async {
      emit(DepositLoading());
      try {
        final response = await DepositService.checkTopUpStatus(event.topUpId);
        if (response.status == "success") {
          emit(DepositSuccess(response));
        } else {
          emit(DepositStatusChecked(response));
        }
      } catch (e) {
        emit(DepositError("Failed to check status: ${e.toString()}"));
      }
    });

    on<DepositWebViewClosed>((event, emit) async {
      // When webview is closed, check the status immediately (usually returns "processing")
      try {
        final response = await DepositService.checkTopUpStatus(event.topUpId);
        if (response.status == "success") {
          emit(DepositSuccess(response));
        } else if (response.status == "processing") {
          emit(DepositProcessing("Payment is being processed..."));
          // Wait 2 seconds and check again
          add(DepositCheckStatusDelayed(event.topUpId));
        } else {
          emit(DepositStatusChecked(response));
        }
      } catch (e) {
        emit(
          DepositError(
            "Failed to check status after webview closed: ${e.toString()}",
          ),
        );
      }
    });

    on<DepositCheckStatusDelayed>((event, emit) async {
      // Wait 2 seconds before checking status again
      await Future.delayed(const Duration(seconds: 2));
      try {
        final response = await DepositService.checkTopUpStatus(event.topUpId);
        if (response.status == "success") {
          emit(DepositSuccess(response));
        } else {
          emit(DepositStatusChecked(response));
        }
      } catch (e) {
        emit(DepositError("Failed to check status: ${e.toString()}"));
      }
    });
  }
}
