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
            SizedBox(height: 16),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
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
                      color:
                          selectedIndex == index
                              ? Theme.of(
                                context,
                              ).colorScheme.onSecondary.withOpacity(0.8)
                              : Theme.of(context).colorScheme.secondary,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            TextField(decoration: InputDecoration(labelText: "Amount")),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
