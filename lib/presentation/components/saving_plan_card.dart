import "package:coinhub/core/bloc/plan/plan_logic.dart";
import "package:coinhub/core/bloc/user/user_logic.dart";
import "package:coinhub/models/plan_model.dart";
import "package:coinhub/models/source_model.dart";
import "package:coinhub/presentation/components/mini_source_card.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class SavingPlanCard extends StatefulWidget {
  final String firstTitle;
  final String secondTitle;
  final String thirdTitle;
  final String userId;

  const SavingPlanCard({
    super.key,
    required this.firstTitle,
    required this.secondTitle,
    required this.thirdTitle,
    required this.userId,
  });

  @override
  State<SavingPlanCard> createState() => SavingPlanCardState();
}

class SavingPlanCardState extends State<SavingPlanCard> {
  late int selectedIndex;
  late int selectedIndexMethod;
  late int selectedIndexPlan;
  final TextEditingController _amountController = TextEditingController();
  late List<PlanModel> plans;
  late List<SourceModel> sources;
  String get selectedSourceId => sources[selectedIndex].id;
  int get selectedPlanId => plans[selectedIndexPlan].planHistoryId!;
  String get selectedMethod =>
      selectedIndexMethod == 0
          ? "NR"
          : selectedIndexMethod == 1
          ? "PR"
          : "PIR";
  int get selectedAmount => int.tryParse(_amountController.text) ?? 0;

  Map<String, dynamic> getSelectedValues() {
    return {
      "sourceId": selectedSourceId,
      "planHistoryId": selectedPlanId,
      "method": selectedMethod,
      "amount": selectedAmount,
    };
  }

  @override
  void initState() {
    selectedIndex = 0;
    selectedIndexMethod = 0;
    selectedIndexPlan = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlanBloc>().add(PlansFetching());
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserBloc>().add(SourcesFetching(widget.userId));
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
        if (state is PlansFetchedSuccess) {
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
        if (state is PlansFetchedError) {
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
        if (state is PlansFetchedSuccess) {
          plans = state.plans;
        } else {
          plans = [];
        }
        return BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is SourcesFetching) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is SourceError) {
              return Center(
                child: Text(state.error, style: TextStyle(color: Colors.red)),
              );
            }
            if (state is SourceFetchedSuccess) {
              sources = state.sources;
            } else {
              sources = [];
            }

            return Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
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
                        itemCount: sources.length,
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
                              moneyInit: sources[index].balance.toString(),
                              sourceId: sources[index].id,
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
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
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
                              moneyInit:
                                  "Rate: ${plans[index].rate.toString()}%",
                              sourceId:
                                  plans[index].days == -1
                                      ? "NR"
                                      : plans[index].days == 30
                                      ? "For: ${(plans[index].days / 30).round().toString()} month"
                                      : "For: ${(plans[index].days / 30).round().toString()} months",
                              icon: Icons.calendar_today_outlined,
                              color: cardColor,
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
      },
    );
  }
}
