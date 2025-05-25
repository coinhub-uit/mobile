import "package:coinhub/presentation/components/provider_card.dart";
import "package:flutter/material.dart";
import "package:coinhub/presentation/components/mini_source_card.dart";
import "package:flutter/services.dart";

class TransactionCard extends StatefulWidget {
  final String title;
  const TransactionCard({super.key, required this.title});

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  late int selectedIndex;
  late int selectedIndexProvider;

  @override
  void initState() {
    selectedIndex = 0;
    selectedIndexProvider = 0;
    super.initState();
  }

  late final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

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
                labelStyle: TextStyle(color: theme.primaryColor, fontSize: 14),
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
                  borderSide: BorderSide(color: theme.primaryColor, width: 2),
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
  }
}
