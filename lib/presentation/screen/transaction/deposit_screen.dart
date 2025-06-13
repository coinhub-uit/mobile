import "package:coinhub/core/bloc/deposit/deposit_logic.dart";
import "package:coinhub/models/user_model.dart";
import "package:coinhub/presentation/components/transaction_card.dart";
import "package:coinhub/presentation/screen/transaction/deposit_webview_screen.dart";
import "package:coinhub/presentation/routes/routes.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";
import "package:go_router/go_router.dart";

class DepositScreen extends StatefulWidget {
  final UserModel model;
  const DepositScreen({super.key, required this.model});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _currentAmount = "";
  String _selectedSourceId = "";

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _processDeposit() {
    if (_formKey.currentState!.validate() && _currentAmount.isNotEmpty) {
      final double? amount = double.tryParse(_currentAmount);

      if (amount == null || amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enter a valid amount"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_selectedSourceId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select a source"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Process deposit using bloc
      context.read<DepositBloc>().add(
        DepositCreateTopUp(
          provider: "vnpay",
          returnUrl: "coinhub://home",
          amount: amount,
          sourceDestinationId: _selectedSourceId,
          ipAddress: "127.0.0.1",
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all required fields"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<DepositBloc, DepositState>(
      listener: (context, state) {
        if (state is DepositError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is DepositTopUpCreated) {
          // Navigate to webview with the payment URL
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => DepositWebViewScreen(
                    paymentUrl: state.response.url,
                    topUpId: state.response.topUpId,
                  ),
            ),
          );
        } else if (state is DepositProcessing) {
          // Show processing dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              final theme = Theme.of(context);
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  "Processing Payment",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          );
        } else if (state is DepositSuccess) {
          // Dismiss any existing dialogs first
          Navigator.of(context).popUntil((route) => route.isFirst);

          // Show success dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              final theme = Theme.of(context);
              final amount = double.tryParse(state.response.amount) ?? 0;
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  "Deposit Successful",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.green[600],
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Your deposit of ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0).format(amount)} has been processed successfully.",
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      context.go(Routes.home);
                    },
                    child: Text(
                      "Go to Home",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        } else if (state is DepositStatusChecked) {
          // Dismiss any existing dialogs first
          Navigator.of(context).popUntil((route) => route.isFirst);

          // Show status dialog for non-success statuses
          showDialog(
            context: context,
            builder: (context) {
              final theme = Theme.of(context);
              final isSuccess = state.response.status == "success";
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  isSuccess ? "Payment Successful" : "Payment Status",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSuccess
                          ? Icons.check_circle_outline
                          : Icons.info_outline,
                      color: isSuccess ? Colors.green[600] : Colors.orange[600],
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Payment status: ${state.response.status}",
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      context.pop();
                      if (isSuccess) {
                        context.go(Routes.home);
                      }
                    },
                    child: Text(
                      isSuccess ? "Go to Home" : "OK",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          title: Text(
            "Deposit",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<DepositBloc, DepositState>(
          builder: (context, state) {
            if (state is DepositLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Deposit Header
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withAlpha(26),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withAlpha(51),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.arrow_downward_rounded,
                                color: theme.primaryColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Deposit Funds",
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Add money to your account",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withAlpha(179),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TransactionCard(
                            title: "Deposit into: ",
                            userId: widget.model.id,
                            formKey: _formKey,
                            onAmountChanged: (value) {
                              setState(() {
                                _currentAmount = value;
                              });
                            },
                            onSourceChanged: (sourceId) {
                              setState(() {
                                _selectedSourceId = sourceId;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              state is DepositLoading ? null : _processDeposit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child:
                              state is DepositLoading
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : Text(
                                    "Deposit",
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
