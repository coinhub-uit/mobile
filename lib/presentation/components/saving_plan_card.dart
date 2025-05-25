import "package:coinhub/core/bloc/plan/plan_logic.dart";
import "package:coinhub/models/plan_model.dart";
import "package:coinhub/presentation/components/mini_source_card.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class SavingPlanCard extends StatefulWidget {
  final String firstTitle;
  final String secondTitle;
  final String thirdTitle;

  const SavingPlanCard({
    super.key,
    required this.firstTitle,
    required this.secondTitle,
    required this.thirdTitle,
  });

  @override
  State<SavingPlanCard> createState() => _SavingPlanCardState();
}

class _SavingPlanCardState extends State<SavingPlanCard> {
  late int selectedIndex;
  late int selectedIndexMethod;
  late int selectedIndexPlan;
  final TextEditingController _amountController = TextEditingController();
  late List<PlanModel> plans;
  @override
  void initState() {
    selectedIndex = 0;
    selectedIndexMethod = 0;
    selectedIndexPlan = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlanBloc>().add(PlanFetching());
    });

    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return BlocConsumer<PlanBloc, PlanState>(
      listener: (context, state) {
        if (state is PlanFetchedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Saving plan fetched successfully"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          _amountController.clear();
          setState(() {
            selectedIndex = 0;
            selectedIndexMethod = 0;
            selectedIndexPlan = 0;
          });
        }
        if (state is PlanFetchedError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        if (state is PlanLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PlanError) {
          return Center(
            child: Text(state.message, style: TextStyle(color: Colors.red)),
          );
        }
        if (state is PlanFetchedSuccess) {
          plans = state.plans;
        } else {
          plans = [];
        }
        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.firstTitle,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      final isSelected = selectedIndex == index;
                      final Color cardColor =
                          isSelected
                              ? (colorScheme.secondary.withOpacity(0.8))
                              : colorScheme.onSurface.withOpacity(0.1);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: MiniSourceCard(
                          icon: Icons.account_balance_wallet,
                          moneyInit: "10000000",
                          sourceId: "098573821",
                          color: cardColor,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: theme.textTheme.headlineSmall,
                  decoration: InputDecoration(
                    labelText: "Amount",
                    labelStyle: TextStyle(
                      color: theme.primaryColor,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.attach_money_outlined,
                      color: theme.primaryColor,
                    ),
                    prefixStyle: theme.textTheme.headlineSmall,
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.dividerTheme.color!,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.primaryColor,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red, width: 1),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter an amount";
                    }
                    if (double.tryParse(value) == null) {
                      return "Please enter a valid amount";
                    }
                    if (double.parse(value) <= 0) {
                      return "Amount must be greater than zero";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  widget.secondTitle,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: plans.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedIndexPlan == index;
                      final Color cardColor =
                          isSelected
                              ? (colorScheme.secondary.withOpacity(0.8))
                              : colorScheme.onSurface.withOpacity(0.1);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndexPlan = index;
                          });
                        },
                        child: MiniSourceCard(
                          moneyInit: "Rate: ${plans[index].rate.toString()}%",
                          sourceId:
                              plans[index].days == -1
                                  ? "NR"
                                  : plans[index].days == 30
                                  ? "For: ${(plans[index].days / 30).round().toString()} month"
                                  : "For: ${(plans[index].days / 30).round().toString()} months",
                          icon: Icons.calendar_today_outlined,
                          color: cardColor,
                          abnormal: true,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.thirdTitle,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      final isSelected = selectedIndexMethod == index;
                      final Color cardColor =
                          isSelected
                              ? (colorScheme.secondary.withOpacity(0.8))
                              : colorScheme.onSurface.withOpacity(0.1);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndexMethod = index;
                          });
                        },
                        child: MiniSourceCard(
                          icon: Icons.calendar_view_day_outlined,
                          moneyInit:
                              index == 0
                                  ? "Non-Renewal"
                                  : index == 1
                                  ? "Principal Renewal"
                                  : "Principal and Interest Renewal",
                          sourceId:
                              index == 0
                                  ? "NR"
                                  : index == 1
                                  ? "PR"
                                  : "PIR",
                          color: cardColor,
                          abnormal: true,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
