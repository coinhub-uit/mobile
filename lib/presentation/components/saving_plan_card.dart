import "package:coinhub/presentation/components/mini_source_card.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";

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
  @override
  void initState() {
    selectedIndex = 0;
    selectedIndexMethod = 0;
    selectedIndexPlan = 0;
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
                      moneyInit: 10000000,
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
                itemCount: 3,
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
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2 - 52,
                        height: 50,
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_view_day_outlined,
                                    size: 30,
                                    color: colorScheme.onSurface,
                                  ),
                                  const SizedBox(width: 8),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          index == 0
                                              ? "NR"
                                              : index == 1
                                              ? "PR"
                                              : "PIR",
                                          style: TextStyle(
                                            color: colorScheme.onSurface,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_view_day_outlined,
                                    size: 30,
                                    color: colorScheme.onSurface,
                                  ),
                                  const SizedBox(width: 8),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          index == 0
                                              ? "Non-Renewal"
                                              : index == 1
                                              ? "Principal Renewal"
                                              : "Principal and Interest Renewal",
                                          style: TextStyle(
                                            color: colorScheme.onSurface,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
