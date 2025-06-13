import "package:coinhub/core/bloc/user/user_logic.dart";
import "package:coinhub/models/source_model.dart";
import "package:coinhub/presentation/components/provider_card.dart";
import "package:flutter/material.dart";
import "package:coinhub/presentation/components/mini_source_card.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class TransactionCard extends StatefulWidget {
  final String title;
  final String userId;
  final Function(String)? onAmountChanged;
  final Function(String)? onSourceChanged;
  final GlobalKey<FormState>? formKey;

  const TransactionCard({
    super.key,
    required this.title,
    required this.userId,
    this.onAmountChanged,
    this.onSourceChanged,
    this.formKey,
  });

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  late int selectedIndex;
  late int selectedIndexProvider;
  late List<SourceModel> sources;

  @override
  void initState() {
    selectedIndex = 0;
    selectedIndexProvider = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserBloc>().add(SourcesFetching(widget.userId));
    });
    super.initState();
  }

  late final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String get amountValue => _amountController.text;

  bool validateForm() {
    if (widget.formKey != null) {
      return widget.formKey!.currentState?.validate() ?? false;
    }
    return _amountController.text.isNotEmpty &&
        double.tryParse(_amountController.text) != null &&
        double.parse(_amountController.text) > 0;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is SourcesError) {
          return Center(
            child: Text(
              "Error loading sources",
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
            ),
          );
        }
        if (state is SourcesLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SourcesFetchedSuccess) {
          sources = state.sources;
          if (sources.isEmpty) {
            return Center(
              child: Text(
                "No sources available",
                style: theme.textTheme.bodyMedium,
              ),
            );
          }
          // Notify parent about the initially selected source
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (sources.isNotEmpty && selectedIndex < sources.length) {
              widget.onSourceChanged?.call(sources[selectedIndex].id);
            }
          });
        } else {
          return Center(
            child: Text(
              "No sources available",
              style: theme.textTheme.bodyMedium,
            ),
          );
        }
        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
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
                    shrinkWrap: true,
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
                          // Notify parent about the selected source
                          widget.onSourceChanged?.call(sources[index].id);
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
                  onChanged: (value) {
                    widget.onAmountChanged?.call(value);
                  },
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
                  "Choose provider:",
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
                      final isSelected = selectedIndexProvider == index;
                      final Color cardColor =
                          isSelected
                              ? (colorScheme.secondary.withOpacity(0.8))
                              : colorScheme.onSurface.withOpacity(0.1);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndexProvider = index;
                          });
                        },
                        child: ProviderCard(
                          color: cardColor,
                          img:
                              index == 0
                                  ? Image.asset(
                                    "assets/images/vnpay.jpg",
                                    width: 24,
                                    height: 24,
                                  )
                                  : index == 1
                                  ? Image.asset(
                                    "assets/images/momo.png",
                                    width: 24,
                                    height: 24,
                                  )
                                  : Image.asset(
                                    "assets/images/zalopay.png",
                                    width: 24,
                                    height: 24,
                                  ),
                          provider:
                              index == 0
                                  ? "Vnpay"
                                  : index == 1
                                  ? "Momo"
                                  : "ZaloPay",
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
