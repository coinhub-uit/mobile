import "package:coinhub/core/bloc/user/user_logic.dart";
import "package:coinhub/models/source_model.dart";
import "package:coinhub/presentation/components/mini_source_card.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class TransferCard extends StatefulWidget {
  final String title;
  final String userId;
  final Function(String)? onAmountChanged;
  final GlobalKey<FormState>? formKey;

  const TransferCard({
    super.key,
    required this.title,
    required this.userId,
    this.onAmountChanged,
    this.formKey,
  });

  @override
  State<TransferCard> createState() => TransferCardState();
}

class TransferCardState extends State<TransferCard> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final int limitLength = 160;
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

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  String get amountValue => _amountController.text;
  String get accountNumber => _accountNumberController.text;
  String get selectedSourceId =>
      sources.isNotEmpty ? sources[selectedIndex].id : "";

  bool validateForm() {
    if (widget.formKey != null) {
      return widget.formKey!.currentState?.validate() ?? false;
    }
    return _amountController.text.isNotEmpty &&
        double.tryParse(_amountController.text) != null &&
        double.parse(_amountController.text) > 0 &&
        _accountNumberController.text.isNotEmpty;
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
                  "Transfer to:",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),

                TextFormField(
                  controller: _accountNumberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: "Account Number",
                    labelStyle: TextStyle(
                      color: theme.primaryColor,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.credit_card_outlined,
                      color: theme.primaryColor,
                    ),
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
                      return "Please enter an account number";
                    }
                    if (value.length < 4) {
                      return "Account number must be at least 4 digits";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 12),
                Text(
                  "From source:",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
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
                SizedBox(height: 16),
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

                SizedBox(height: 12),
                TextField(
                  maxLines: 4,
                  minLines: 3,
                  controller: _descriptionController,
                  maxLength: limitLength,
                  decoration: InputDecoration(
                    labelText: "Description",
                    labelStyle: TextStyle(
                      color: theme.primaryColor,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.description_outlined,
                      color: theme.primaryColor,
                    ),
                    counterText:
                        "${_descriptionController.text.length}/$limitLength",
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
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),

                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
