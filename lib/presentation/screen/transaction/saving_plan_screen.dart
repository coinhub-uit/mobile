import "package:coinhub/models/user_model.dart";
import "package:coinhub/presentation/components/saving_plan_card.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:intl/intl.dart";

class SavingPlanScreen extends StatefulWidget {
  final UserModel model; // Replace 'dynamic' with the actual type if known
  const SavingPlanScreen({super.key, required this.model});

  @override
  State<SavingPlanScreen> createState() => _SavingPlanScreenState();
}

class _SavingPlanScreenState extends State<SavingPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  void _processWithdraw() {}
  // Mock balance for demonstration
  final double _balance = 21987000;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      locale: "vi_VN",
      symbol: "đ",
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "New Saving Plan",
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
          onPressed: () => Navigator.of(context).pop(),
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
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.primaryColor,
                        theme.primaryColor.withBlue(255),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primaryColor.withAlpha(77),
                        blurRadius: 10,
                        spreadRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Available Balance",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withAlpha(204),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currencyFormat.format(_balance),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                // Withdraw Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _processWithdraw,
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
                      "Create Saving Plan",
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
  }
}
