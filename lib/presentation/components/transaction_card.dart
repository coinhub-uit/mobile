import "package:flutter/material.dart";
import "package:coinhub/presentation/components/mini_source_card.dart";

class TransactionCard extends StatefulWidget {
  final String title;
  const TransactionCard({super.key, required this.title});

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  late int selectedIndex;

  @override
  void initState() {
    selectedIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
                          ? colorScheme.onSecondary.withValues(
                            alpha: (0.8 * 255).round().toDouble(),
                          )
                          : colorScheme.secondary;

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
            const TextField(decoration: InputDecoration(labelText: "Amount")),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
