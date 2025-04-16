import "package:flutter/material.dart";
import "package:coinhub/presentation/components/transaction_card.dart";

class DepositScreen extends StatelessWidget {
  const DepositScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Deposit",
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
          children: [TransactionCard(title: "Deposit into: ")],
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
              "Deposit",
              style: Theme.of(
                context,
              ).textTheme.headlineLarge!.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
