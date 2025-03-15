import "package:coinhub/presentation/components/transaction_card.dart";
import "package:flutter/material.dart";
import "package:coinhub/presentation/components/transaction_card.dart";

class WithdrawScreen extends StatelessWidget {
  const WithdrawScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Withdraw",
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TransactionCard(title: "Withdraw from: "),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 60, // Adjust height
          child: FloatingActionButton(
            onPressed: () {
              // Add onPressed
            },
            child: Text(
              "Withdraw",
              style: Theme.of(
                context,
              ).textTheme.displayMedium!.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
