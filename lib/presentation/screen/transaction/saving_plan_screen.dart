import "package:coinhub/core/bloc/ticket/ticket_logic.dart";
import "package:coinhub/core/services/security_service.dart";
import "package:coinhub/core/services/ticket_service.dart";
import "package:coinhub/models/ticket_model.dart";
import "package:coinhub/models/user_model.dart";
import "package:coinhub/presentation/components/saving_plan_card.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

class SavingPlanScreen extends StatefulWidget {
  final UserModel model; // Replace 'dynamic' with the actual type if known
  const SavingPlanScreen({super.key, required this.model});

  @override
  State<SavingPlanScreen> createState() => _SavingPlanScreenState();
}

class _SavingPlanScreenState extends State<SavingPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _methodController = TextEditingController();
  final TextEditingController _planIdController = TextEditingController();
  final TextEditingController _sourceIdController = TextEditingController();
  final GlobalKey<SavingPlanCardState> _cardKey =
      GlobalKey<SavingPlanCardState>();
  bool _isProcessing = false; // Add flag

  @override
  void dispose() {
    _amountController.dispose();
    _methodController.dispose();
    _planIdController.dispose();
    _sourceIdController.dispose();
    super.dispose();
  }

  void _processCreateTicket() async {
    if (_isProcessing) return; // Prevent multiple calls
    setState(() => _isProcessing = true); // Disable button

    print("Starting _processCreateTicket");
    final authenticated =
        await SecurityService.authenticateForSensitiveOperation(
          context,
          title: "Confirm New Ticket Creation",
          subtitle: "Please authenticate to create a ticket",
          type: AuthenticationType.sensitiveOperation,
        );

    if (!authenticated) {
      print("Authentication failed");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Authentication required to create ticket"),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _isProcessing = false);
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      final values = _cardKey.currentState?.getSelectedValues();
      print("Form validated, values: $values");
      if (values == null) {
        setState(() => _isProcessing = false);
        return;
      }

      final sourceId = values["sourceId"] as String;
      final planHistoryId = values["planHistoryId"] as int;
      final method = values["method"] as String;
      final amount = values["amount"] as int;
      print(
        "TicketModel data: sourceId: $sourceId, planHistoryId: $planHistoryId, method: $method, amount: $amount",
      );

      if (amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Amount must be greater than 0"),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isProcessing = false);
        return;
      }

      try {
        final minAmount = await TicketService.getMinAmountOpenTicket();
        if (amount < minAmount) {
          print("Amount is less than minimum required: $minAmount");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Amount must be at least $minAmount"),
              backgroundColor: Colors.red,
            ),
          );
          setState(() => _isProcessing = false);
          return;
        }

        context.read<TicketBloc>().add(
          TicketCreating(
            TicketModel(
              method: method,
              planHistoryId: planHistoryId,
              sourceId: sourceId,
              amount: amount.toInt(),
            ),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Ticket creating..."),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.blue,
          ),
        );
      } catch (e) {
        print("Error validating minimum amount: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: Failed to validate ticket data: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      print("Form validation failed");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields correctly."),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() => _isProcessing = false); // Re-enable button
  }

  // Mock balance for demonstration
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final currencyFormat = NumberFormat.currency(
    //   locale: "vi_VN",
    //   symbol: "đ",
    //   decimalDigits: 0,
    // );

    return BlocConsumer<TicketBloc, TicketState>(
      listener: (context, state) {
        if (state is TicketCreatedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Ticket created successfully!"),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
          context.pop(true);
        } else if (state is TicketError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: ${state.message}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is TicketLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            title: Text(
              "New Ticket",
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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Balance Card
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
                              Icons.savings_rounded,
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
                                  "Create New Ticket",
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Manage your financial goals with ease",
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

                    // Withdraw Form
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SavingPlanCard(
                          firstTitle: "Choose funding source: ",
                          thirdTitle: "Choose saving method: ",
                          secondTitle: "Choose saving plan:",
                          userId: widget.model.id,
                          key: _cardKey,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _processCreateTicket,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Create Ticket",
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
          ),
        );
      },
    );
  }
}
